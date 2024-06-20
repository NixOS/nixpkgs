{ lib, stdenv
, fetchurl
, libedit
}:

stdenv.mkDerivation rec {
  name = "funlisp";
  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/brenns10/funlisp/releases/download/v${version}/funlisp-${version}.tar.gz";
    hash = "sha256-sO9XbGUZOCVfY0IsJLieLspPs+pVruveFNOxYNQJmf0=";
  };

  enableParallelBuilding = true;

  buildInputs = [ libedit ];

  installPhase = ''
     # Install library
     make PREFIX=$out install

     # Default install only includes the library and manpage, so install
     # useful repl binary manually.
     install -d $out/bin
     install bin/funlisp $out/bin
  '';

  doCheck = true;
  checkPhase = ''
    # Simple smoke test
    test $(bin/funlisp <(echo "(print (* 2 21))")) -eq 42
  '';

  meta = with lib; {
    description = "Simple, embeddable lisp interpreter";
    homepage = "https://github.com/brenns10/funlisp";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
