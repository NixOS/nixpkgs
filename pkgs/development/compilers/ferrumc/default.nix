{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "ferrumc";
  version = "0.3.0";

  src = fetchurl (if stdenv.hostPlatform.isLinux then
    if stdenv.hostPlatform.isAarch64 then {
      url = "https://github.com/Ferrum-Language/Ferrum/releases/download/v${version}/ferrumc-v${version}-linux-aarch64.tar.gz";
      hash = "sha256-QySBU3bBO4A4cFhkgFxNWw5EkQtmxSYxEesx+s6Uz5w=";
    } else {
      url = "https://github.com/Ferrum-Language/Ferrum/releases/download/v${version}/ferrumc-v${version}-linux-x86_64.tar.gz";
      hash = "sha256-JzXPcC/5w/O/mtlRQL3iEfPmQlkOkiKAD4GWlyf+YCk=";
    }
  else if stdenv.hostPlatform.isDarwin then
    if stdenv.hostPlatform.isAarch64 then {
      url = "https://github.com/Ferrum-Language/Ferrum/releases/download/v${version}/ferrumc-v${version}-macos-arm64.tar.gz";
      hash = "sha256-3Smma7L4Wf8fB/x3SU2N/k6fVo4TIWJTAW2PrShE1g=";
    } else {
      url = "https://github.com/Ferrum-Language/Ferrum/releases/download/v${version}/ferrumc-v${version}-macos-x86_64.tar.gz";
      hash = "sha256-vCL+r5I4KdTI8Y/ytpq07TNptSuC2kJDARZ75IAcUC8=";
    }
  else throw "Unsupported platform");

  dontUnpack = false;
  dontBuild = true;

  installPhase = '
    install -Dm755 ferrumc $out/bin/ferrumc
  ';

  meta = {
    description = "Ferrum-language compiler with compile-time memory safety";
    longDescription = '
      Ferrum-language is a systems programming language with C syntax and
      compile-time memory safety via a borrow checker and ownership model,
      compiled to native code through LLVM 18.
    ';
    homepage = "https://ferrum-language.github.io/Ferrum/";
    license = lib.licenses.mit;
    maintainers = [];
    platforms = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "ferrumc";
  };
}
