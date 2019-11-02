{ stdenv, fetchFromGitHub, buildDunePackage
, ocaml-compiler-libs, ocaml-migrate-parsetree, ppx_derivers, stdio
}:

buildDunePackage rec {
  pname = "ppxlib";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = pname;
    rev = version;
    sha256 = "0vm0jajmg8135scbg0x60ivyy5gzv4abwnl7zls2mrw23ac6kml6";
  };

  propagatedBuildInputs = [
    ocaml-compiler-libs ocaml-migrate-parsetree ppx_derivers stdio
  ];

  meta = {
    description = "Comprehensive ppx tool set";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
