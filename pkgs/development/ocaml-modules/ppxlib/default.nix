{ lib, fetchFromGitHub, buildDunePackage, ocaml
, legacy ? false
, ocaml-compiler-libs, ocaml-migrate-parsetree, ppx_derivers, stdio
}:

let param =
  if legacy then {
    version = "0.8.1";
    sha256 = "0vm0jajmg8135scbg0x60ivyy5gzv4abwnl7zls2mrw23ac6kml6";
  } else {
    version = "0.12.0";
    sha256 = "1cg0is23c05k1rc94zcdz452p9zn11dpqxm1pnifwx5iygz3w0a1";
  }; in

if lib.versionAtLeast ocaml.version "4.10" && legacy
then throw "ppxlib-${param.version} is not available for OCaml ${ocaml.version}"
else

buildDunePackage rec {
  pname = "ppxlib";
  inherit (param) version;

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
