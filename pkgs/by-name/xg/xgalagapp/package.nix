{
  lib,
  stdenv,
  fetchurl,
  libX11,
  libXpm,
}:

stdenv.mkDerivation rec {
  pname = "xgalaga++";
  version = "0.9";
  src = fetchurl {
    url = "https://marc.mongenet.ch/OSS/XGalaga/xgalaga++_${version}.tar.gz";
    sha256 = "sha256-yNtLuYCMHLvQAVM7CDGPardrh3q27TE9l31qhUbMf8k=";
  };

  buildInputs = [
    libX11
    libXpm
  ];

  buildFlags = [
    "all"
    "HIGH_SCORES_FILE=.xgalaga++.scores"
    "CXX=${stdenv.cc.targetPrefix}c++" # fix darwin and cross-compiled builds
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/man
    mv xgalaga++ $out/bin
    mv xgalaga++.6x $out/share/man

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://marc.mongenet.ch/OSS/XGalaga/";
    description = "XGalaga++ is a classic single screen vertical shoot ’em up. It is inspired by XGalaga and reuses most of its sprites";
    mainProgram = "xgalaga++";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
