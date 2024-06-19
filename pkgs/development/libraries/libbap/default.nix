{ lib, stdenv, fetchFromGitHub, bap, ocaml, findlib, ctypes, ctypes-foreign, autoreconfHook,
  which }:

stdenv.mkDerivation {
  pname = "libbap";
  version = "master-2022-07-13";

  src = fetchFromGitHub {
    owner = "BinaryAnalysisPlatform";
    repo = "bap-bindings";
    rev = "4d324dd794f8e022e8eddecbb2ae2e7b28173947";
    hash = "sha256-la47HR+i99ueDEWR91YIXGdKflpE1E0qmmJjeowmGSI=";
  };

  nativeBuildInputs = [ autoreconfHook which ocaml findlib ];
  buildInputs = [ bap ctypes ctypes-foreign ];

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
