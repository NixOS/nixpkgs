{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zasm";
  version = "4.4.17";

  src = fetchFromGitHub {
    owner = "megatokio";
    repo = "zasm";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-nc8hlGfix9eVTP5ZimmLKv22cdfsKRfrG70brpUh6CA=";
    postFetch = ''
      # remove folder containing files with weird names (causes the hash to turn out differently under macOS vs. Linux)
      rm -rv $out/Test
    '';
  };

  buildInputs = [ zlib ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "CXX=${stdenv.cc.targetPrefix}c++"
    "LINK=${stdenv.cc.targetPrefix}c++"
    "STRIP=${stdenv.cc.targetPrefix}strip"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin zasm

    runHook postInstall
  '';

  meta = {
    description = "Z80 / 8080 / Z180 assembler (for unix-style OS)";
    mainProgram = "zasm";
    homepage = "https://k1.spdns.de/Develop/Projects/zasm/Distributions/";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.turbomack ];
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.aarch64;
  };
})
