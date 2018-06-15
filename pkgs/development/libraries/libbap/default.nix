{ stdenv, fetchFromGitHub, bap, ocaml, findlib, ctypes, autoreconfHook,
  which }:

stdenv.mkDerivation rec {
  name = "libbap-${version}";
  version = "master-2018-03-01";

  src = fetchFromGitHub {
    owner = "BinaryAnalysisPlatform";
    repo = "bap-bindings";
    rev = "bd125c379a784d4265c2ddcf1f6e34bde2e568d4";
    sha256 = "0dp90djyjc262v1b1cw5irp424a8394y86fyprdk8z741wg56m3v";
  };

  nativeBuildInputs = [ autoreconfHook which ];
  buildInputs = [ ocaml bap findlib ctypes ];

  preInstall = ''
    mkdir -p $out/lib
    mkdir -p $out/include
  '';

  meta = {
    homepage = https://github.com/binaryanalysisplatform/bap-bindings;
    description = "A C library for interacting with BAP";
    maintainers = [ stdenv.lib.maintainers.maurer ];
    platforms = stdenv.lib.platforms.unix;
  };
}
