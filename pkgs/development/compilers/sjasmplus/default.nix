{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "sjasmplus";
  version = "1.18.3";

  src = fetchFromGitHub {
    owner = "z00m128";
    repo = "sjasmplus";
    rev = "v${version}";
    sha256 = "sha256-+FvNYfJ5I91RfuJTiOPhj5KW8HoOq8OgnnpFEgefSGc=";
  };

  buildFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ];

  installPhase = ''
    runHook preInstall
    install -D sjasmplus $out/bin/sjasmplus
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://z00m128.github.io/sjasmplus/";
    description = "Z80 assembly language cross compiler. It is based on the SjASM source code by Sjoerd Mastijn";
    mainProgram = "sjasmplus";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ electrified ];
  };
}
