{ lib, fetchFromGitHub, buildDunePackage, ocaml
, version ?
  if lib.versionAtLeast ocaml.version "4.07"
  then if lib.versionAtLeast ocaml.version "4.08"
  then "0.24.0" else "0.15.0" else "0.13.0"
, ocaml-compiler-libs, ocaml-migrate-parsetree, ppx_derivers, stdio
, stdlib-shims, ocaml-migrate-parsetree-2
}:

let param = {
  "0.8.1" = {
    sha256 = "0vm0jajmg8135scbg0x60ivyy5gzv4abwnl7zls2mrw23ac6kml6";
    max_version = "4.10";
    useDune2 = false;
    useOMP2 = false;
  };
  "0.13.0" = {
    sha256 = "0c54g22pm6lhfh3f7s5wbah8y48lr5lj3cqsbvgi99bly1b5vqvl";
    useDune2 = false;
    useOMP2 = false;
  };
  "0.15.0" = {
    sha256 = "1p037kqj5858xrhh0dps6vbf4fnijla6z9fjz5zigvnqp4i2xkrn";
    min_version = "4.07";
    max_version = "4.12";
    useOMP2 = false;
  };
  "0.18.0" = {
    sha256 = "1ciy6va2gjrpjs02kha83pzh0x1gkmfsfsdgabbs1v14a8qgfibm";
    min_version = "4.07";
    max_version = "4.12";
  };
  "0.22.0" = {
    sha256 = "0kf7lgcwygf6zlx7rwddqpqvasa6v7xiq0bqal8vxlib6lpg074q";
    min_version = "4.07";
  };
  "0.22.2" = {
    sha256 = "0fysjqcpv281n52wl3h0dy2lzf9d61wdzk90ldv3p63a4i3mr1j2";
    min_version = "4.07";
  };
  "0.23.0" = {
    sha256 = "0jg5v4pssbl66hn5davpin1i57a0r3r54l96vpz5y99xk5w70xi1";
    min_version = "4.07";
  };
  "0.24.0" = {
    sha256 = "sha256-wuG7cUZiVP2PdM+nZloip7lGGiWn6Wpkh2YoF/Fuc9o=";
    min_version = "4.07";
  };
}."${version}"; in

if param ? max_version && lib.versionAtLeast ocaml.version param.max_version
|| param ? min_version && !lib.versionAtLeast ocaml.version param.min_version
then throw "ppxlib-${version} is not available for OCaml ${ocaml.version}"
else

buildDunePackage rec {
  pname = "ppxlib";
  inherit version;

  useDune2 = param.useDune2 or true;

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = pname;
    rev = version;
    inherit (param) sha256;
  };

  propagatedBuildInputs = [
    ocaml-compiler-libs
    (if param.useOMP2 or true
     then ocaml-migrate-parsetree-2
     else ocaml-migrate-parsetree)
    ppx_derivers
    stdio
    stdlib-shims
  ];

  meta = {
    description = "Comprehensive ppx tool set";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
