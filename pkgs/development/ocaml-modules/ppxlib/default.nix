{ stdenv, fetchFromGitHub, buildDunePackage
, version ? "0.8.1"
, ocaml-compiler-libs, ocaml-migrate-parsetree, ppx_derivers, stdio
}:

let sha256 =
  { "0.8.1" = "0vm0jajmg8135scbg0x60ivyy5gzv4abwnl7zls2mrw23ac6kml6";
    "0.12.0" = "1cg0is23c05k1rc94zcdz452p9zn11dpqxm1pnifwx5iygz3w0a1";
  }."${version}"
; in

buildDunePackage rec {
  pname = "ppxlib";
  inherit version;

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = pname;
    rev = version;
    inherit sha256;
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
