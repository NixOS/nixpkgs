{ lib, fetchFromGitHub, buildDunePackage, ocaml
, version ? "0.13.0"
, ocaml-compiler-libs, ocaml-migrate-parsetree, ppx_derivers, stdio
}:

let param = {
  "0.8.1" = {
    sha256 = "0vm0jajmg8135scbg0x60ivyy5gzv4abwnl7zls2mrw23ac6kml6";
    max_version = "4.10";
  };
  "0.13.0" = {
    sha256 = "0c54g22pm6lhfh3f7s5wbah8y48lr5lj3cqsbvgi99bly1b5vqvl";
  };
}."${version}"; in

if param ? max_version && lib.versionAtLeast ocaml.version param.max_version
|| param ? min_version && !lib.versionAtLeast ocaml.version param.min_version
then throw "ppxlib-${param.version} is not available for OCaml ${ocaml.version}"
else

buildDunePackage rec {
  pname = "ppxlib";
  inherit version;

  useDune2 = param.useDune2 or false;

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = pname;
    rev = version;
    inherit (param) sha256;
  };

  propagatedBuildInputs = [
    ocaml-compiler-libs ocaml-migrate-parsetree ppx_derivers stdio
  ];

  meta = {
    description = "Comprehensive ppx tool set";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
