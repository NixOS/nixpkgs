{ stdenv, fetchFromGitHub, ocaml, findlib, camlp5
, ppx_tools_versioned, ppx_deriving, re
}:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-elpi-${version}";
  version = "1.0.5";
  src = fetchFromGitHub {
    owner = "LPCIC";
    repo = "elpi";
    rev = "v${version}";
    sha256 = "1n1m183l4ms949m2l24w0887m1rmvc9b3j8alnbw8ckn6wwnhpmk";
  };

  buildInputs = [ ocaml findlib ppx_tools_versioned ];

  propagatedBuildInputs = [ camlp5 ppx_deriving re ];

  createFindlibDestdir = true;

  preInstall = "make byte";

  postInstall = ''
    mkdir -p $out/bin
    make install-bin BIN=$out/bin
    make install-bin BYTE=1 BIN=$out/bin
  '';

  meta = {
    description = "Embeddable λProlog Interpreter";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
  };
}
