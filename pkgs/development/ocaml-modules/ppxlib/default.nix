{ stdenv, fetchFromGitHub, buildDunePackage
, ocaml-compiler-libs, ocaml-migrate-parsetree, ppx_derivers, stdio
}:

buildDunePackage rec {
  pname = "ppxlib";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = pname;
    rev = version;
    sha256 = "1cg0is23c05k1rc94zcdz452p9zn11dpqxm1pnifwx5iygz3w0a1";
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
