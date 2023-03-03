{ lib, stdenv, fetchFromGitHub, bap, ocaml, findlib, ctypes, autoreconfHook,
  which }:

stdenv.mkDerivation {
  pname = "libbap";
  version = "master-2020-11-25";

  src = fetchFromGitHub {
    owner = "BinaryAnalysisPlatform";
    repo = "bap-bindings";
    rev = "3193cb31e1b1f2455406ea0c819dad9dfa2ba10d";
    sha256 = "0m4spva3z6fgbwlg4zq53l5p227dic893q2qq65pvzxyf7k7nmil";
  };

  postPatch = ''
    substituteInPlace Makefile.in \
      --replace "-linkpkg" "-thread -linkpkg"
  '';

  nativeBuildInputs = [ autoreconfHook which ocaml findlib ];
  buildInputs = [ bap ctypes ];

  preInstall = ''
    mkdir -p $out/lib
    mkdir -p $out/include
  '';

  meta = with lib; {
    homepage = "https://github.com/binaryanalysisplatform/bap-bindings";
    description = "A C library for interacting with BAP";
    maintainers = [ maintainers.maurer ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
