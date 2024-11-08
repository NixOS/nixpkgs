{ lib
, stdenv
, fetchurl
, _7zz
, dpkg
, autoPatchelfHook
, wrapGAppsHook3
, makeWrapper
, alsa-lib
, at-spi2-atk
, cups
, nspr
, nss
, mesa # for libgbm
, xorg
, xdg-utils
, libdrm
, libnotify
, libsecret
, libuuid
, gtk3
, systemd
}:
let
  pname = "yesplaymusic";
  version = "0.4.8-2";

  srcs = let
    version' = lib.head (lib.splitString "-" version);
  in {
    x86_64-linux = fetchurl {
      url = "https://github.com/qier222/YesPlayMusic/releases/download/v${version}/yesplaymusic_${version'}_amd64.deb";
      hash = "sha256-iTWi+tZGUQU7J1mcmMdlWXSKpYGy4mMAeq9CN9fhnZ8=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/qier222/YesPlayMusic/releases/download/v${version}/yesplaymusic_${version'}_arm64.deb";
      hash = "sha256-PP0apybSORqleOBogldgIV1tYZqao8kZ474muAEDpd0";
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/qier222/YesPlayMusic/releases/download/v${version}/YesPlayMusic-mac-${version'}-x64.dmg";
      hash = "sha256-UHnEdoXT/vArSRKXPlfDYUUUMDyF2mnDsmJEjACW2vo=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/qier222/YesPlayMusic/releases/download/v${version}/YesPlayMusic-mac-${version'}-arm64.dmg";
      hash = "sha256-FaeumNmkPQYj9Ae2Xw/eKUuezR4bEdni8li+NRU9i1k=";
    };
  };
  src = srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  libraries = [
    alsa-lib
    at-spi2-atk
    cups
    nspr
    nss
    mesa
    xorg.libxshmfence
    xorg.libXScrnSaver
    xorg.libXtst
    xdg-utils
    libdrm
    libnotify
    libsecret
    libuuid
    gtk3
  ];

  meta = with lib; {
    description = "Good-looking third-party netease cloud music player";
    mainProgram = "yesplaymusic";
    homepage = "https://github.com/qier222/YesPlayMusic/";
    license = licenses.mit;
    maintainers = with maintainers; [ ChaosAttractor ];
    platforms = builtins.attrNames srcs;
  };
in
if stdenv.hostPlatform.isDarwin
then stdenv.mkDerivation {
  inherit pname version src meta;

  nativeBuildInputs = [ _7zz makeWrapper ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    makeWrapper $out/Applications/YesPlayMusic.app/Contents/MacOS/YesPlayMusic $out/bin/yesplaymusic

    runHook postInstall
  '';
}
else stdenv.mkDerivation {
  inherit pname version src meta;

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook3
    makeWrapper
  ];

  buildInputs = libraries;

  runtimeDependencies = [
    (lib.getLib systemd)
  ];

  unpackPhase = ''
    ${dpkg}/bin/dpkg-deb -x $src .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r opt $out/opt
    cp -r usr/share $out/share
    substituteInPlace $out/share/applications/yesplaymusic.desktop \
      --replace "/opt/YesPlayMusic/yesplaymusic" "$out/bin/yesplaymusic"
    makeWrapper $out/opt/YesPlayMusic/yesplaymusic $out/bin/yesplaymusic \
      --argv0 "yesplaymusic" \
      --add-flags "$out/opt/YesPlayMusic/resources/app.asar"

    runHook postInstall
  '';
}
