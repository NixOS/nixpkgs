{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "sjasmplus";
  version = "1.18.2";

  src = fetchFromGitHub {
    owner = "z00m128";
    repo = "sjasmplus";
    rev = "v${version}";
    sha256 = "04348zcmc0b3crzwhvj1shx6f1n3x05vs8d5qdm7qhgdfki8r74v";
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
    description = "A Z80 assembly language cross compiler. It is based on the SjASM source code by Sjoerd Mastijn";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ electrified ];
  };
}
