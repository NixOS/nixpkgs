{ lib, stdenv, fetchFromGitHub, bap, ocaml, findlib, ctypes, autoreconfHook,
  which }:

stdenv.mkDerivation {
  pname = "libbap";
  version = "master-2019-11-15";

  src = fetchFromGitHub {
    owner = "BinaryAnalysisPlatform";
    repo = "bap-bindings";
    rev = "1a30dd3e1df18c432a83a7038b555662d6982ae3";
    sha256 = "140gmak2kymh3r0fagb6ms66lmvwhhqj8pcd3qxc1p4ar330fwrh";
  };

  nativeBuildInputs = [ autoreconfHook which ];
  buildInputs = [ ocaml bap findlib ctypes ];

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
