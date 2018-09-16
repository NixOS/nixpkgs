{ stdenv, fetchFromGitHub, ocaml, findlib, dune
, angstrom, faraday, alcotest
}:

stdenv.mkDerivation rec {
  version = "0.4.1";
  name = "ocaml${ocaml.version}-httpaf-${version}";

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = "httpaf";
    rev = version;
    sha256 = "0i2r004ihj00hd97475y8nhjqjln58xx087zcjl0dfp0n7q80517";
  };

  buildInputs = [ ocaml findlib dune alcotest ];
  propagatedBuildInputs = [ angstrom faraday ];

  buildPhase = "dune build -p httpaf";

  doCheck = true;
  checkPhase = "dune runtest -p httpaf";

  inherit (dune) installPhase;

  meta = {
    description = "A high-performance, memory-efficient, and scalable web server for OCaml";
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
  };
}
