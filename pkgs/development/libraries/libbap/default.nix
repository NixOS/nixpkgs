{ stdenv, fetchFromGitHub, bap, ocaml, findlib, ctypes, autoreconfHook,
  which }:

stdenv.mkDerivation rec {
  name = "libbap-${version}";
  version = "master-2017-02-08";

  src = fetchFromGitHub {
    owner = "BinaryAnalysisPlatform";
    repo = "bap-bindings";
    rev = "b3da5bd5cdb3d646015ccdeb886b5ea8fd85a108";
    sha256 = "0cwfyfpxbi9bm4kkpamyd7mgsm5b6j1rh217fqb5gi05wg45rkbb";
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
