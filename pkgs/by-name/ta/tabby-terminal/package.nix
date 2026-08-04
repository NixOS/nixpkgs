{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  wrapGAppsHook3,
  glib,
  gtk3,
  gsettings-desktop-schemas,
  nss,
  nspr,
  dbus,
  at-spi2-atk,
  cups,
  cairo,
  pango,
  atk,
  libdrm,
  mesa,
  libglvnd,
  libxkbcommon,
  alsa-lib,
  expat,
  libnotify,
  libsecret,
  libappindicator-gtk3,
  libx11,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  libxcb,
  libxtst,
}:

let
  version = "1.0.230";

  platformInfo = {
    "x86_64-linux" = {
      url = "https://github.com/Eugeny/tabby/releases/download/v${version}/tabby-${version}-linux-x64.deb";
      hash = "sha256-ZDyUIADOS2vvfRX485ae7Q7fhtGG24vsDRRMnlAqnQk=";
    };
    "aarch64-linux" = {
      url = "https://github.com/Eugeny/tabby/releases/download/v${version}/tabby-${version}-linux-arm64.deb";
      hash = "sha256-HjSW9oaFVI7Pb+dYX0Yd6wFQX9DkZ6nKic3KZ+6RSmQ=";
    };
  };

  selectedPlatform =
    platformInfo.${stdenv.hostPlatform.system}
      or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");
in

stdenv.mkDerivation {
  pname = "tabby";
  inherit version;

  src = fetchurl {
    url = selectedPlatform.url;
    hash = selectedPlatform.hash;
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    gsettings-desktop-schemas
    nss
    nspr
    dbus
    at-spi2-atk
    cups
    cairo
    pango
    atk
    libdrm
    mesa
    libglvnd
    libxkbcommon
    alsa-lib
    expat
    libnotify
    libsecret
    libappindicator-gtk3
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxcb
    libxtst
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x $src .
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    cp -r opt/Tabby $out/opt/

    mkdir -p $out/share
    cp -r usr/share/applications $out/share/
    cp -r usr/share/icons $out/share/

    mkdir -p $out/bin
    ln -s $out/opt/Tabby/tabby $out/bin/tabby

    runHook postInstall
  '';

  postInstall = ''
    rm $out/opt/Tabby/resources/app.asar.unpacked/node_modules/@serialport/bindings-cpp/prebuilds/linux-x64/node.napi.musl.node
    substituteInPlace $out/share/applications/tabby.desktop --replace "/opt/Tabby/tabby" "tabby"
  '';

  gappsWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        mesa
        libglvnd
      ]
    }"
  ];

  meta = {
    description = "Terminal for a modern age";
    homepage = "https://tabby.sh/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.aliheidary1381 ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "tabby";
  };
}
