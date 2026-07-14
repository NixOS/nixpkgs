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

stdenv.mkDerivation rec {
  pname = "tabby";
  version = "1.0.230";

  src = fetchurl {
    url =
      if stdenv.hostPlatform.system == "x86_64-linux" then
        "https://github.com/Eugeny/${pname}/releases/download/v${version}/${pname}-${version}-linux-x64.deb"
      else if stdenv.hostPlatform.system == "aarch64-linux" then
        "https://github.com/Eugeny/${pname}/releases/download/v${version}/${pname}-${version}-linux-arm64.deb"
      else
        throw "Unsupported platform: ${stdenv.hostPlatform.system}";

    hash =
      if stdenv.hostPlatform.system == "x86_64-linux" then
        "sha256-ZDyUIADOS2vvfRX485ae7Q7fhtGG24vsDRRMnlAqnQk="
      else if stdenv.hostPlatform.system == "aarch64-linux" then
        "sha256-HjSW9oaFVI7Pb+dYX0Yd6wFQX9DkZ6nKic3KZ+6RSmQ="
      else
        throw "Unsupported platform: ${stdenv.hostPlatform.system}";
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
    rm -f $out/opt/Tabby/resources/app.asar.unpacked/node_modules/@serialport/bindings-cpp/prebuilds/linux-x64/node.napi.musl.node
    substituteInPlace $out/share/applications/tabby.desktop --replace "/opt/Tabby/tabby" "$out/bin/tabby"
  '';

  gappsWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        mesa
        libglvnd
      ]
    }"
  ];

  meta = with lib; {
    description = "A terminal for a modern age";
    homepage = "https://tabby.sh/";
    license = licenses.mit;
    maintainers = [ maintainers.aliheidary1381 ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "tabby";
  };
}
