{ stdenv, fetchFromGitHub, buildDunePackage
, version ? "0.13.0"
, ocaml-compiler-libs, ocaml-migrate-parsetree, ppx_derivers, stdio
}:

let sha256 =
  { "0.13.0" = "0c54g22pm6lhfh3f7s5wbah8y48lr5lj3cqsbvgi99bly1b5vqvl";
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
