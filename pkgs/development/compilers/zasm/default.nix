{ lib, stdenv, fetchFromGitHub, zlib }:
let
  libs-src = fetchFromGitHub {
    owner = "megatokio";
    repo = "Libraries";
    # 2021-02-02
    rev = "c5cb3ed512c677db6f33e2d3539dfbb6e547030b";
    sha256 = "sha256-GiplhZf640uScVdKL6E/fegOgtC9SE1xgBqcX86XADk=";
  };
in
stdenv.mkDerivation rec {
  pname = "zasm";
  version = "4.4.7";

  src = fetchFromGitHub {
    owner = "megatokio";
    repo = "zasm";
    rev = version;
    sha256 = "sha256-Zbno8kmzss1H2FjwzHB4U7UXxa6oDfsPV80MVVFfM68=";
    postFetch = ''
      # remove folder containing files with weird names (causes the hash to turn out differently under macOS vs. Linux)
      rm -rv $out/Test
    '';
  };

  buildInputs = [ zlib ];

  configurePhase = ''
    ln -sf ${libs-src} Libraries
  '';

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "CXX=${stdenv.cc.targetPrefix}c++"
    "LINK=${stdenv.cc.targetPrefix}c++"
    "STRIP=${stdenv.cc.targetPrefix}strip"
  ];

  installPhase = ''
    install -Dm755 -t $out/bin zasm
  '';

  meta = with lib; {
    description = "Z80 / 8080 / Z180 assembler (for unix-style OS)";
    mainProgram = "zasm";
    homepage = "https://k1.spdns.de/Develop/Projects/zasm/Distributions/";
    license = licenses.bsd2;
    maintainers = [ maintainers.turbomack ];
    platforms = platforms.unix;
    badPlatforms = platforms.aarch64;
  };
}
