{
  stdenv,
  fetchurl,
  alsa-lib,
  nss,
  libdrm,
  mesa,
  glib,
  nspr,
  atk,
  cups,
  dbus,
  gtk3,
  pango,
  cairo,
  gdk-pixbuf,
  xorg,
  expat,
  libxkbcommon,
  gnome,
  harfbuzzFull,
  dpkg,
  makeWrapper,
  autoPatchelfHook,
  patchelf,
  lsb-release,
  xdg-utils,
  xdg-user-dirs,
  lib,
  udev,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "SynologyChat";
  version = "1.2.3-0232";

  src = fetchurl {
    url = "https://global.download.synology.com/download/Utility/ChatClient/${finalAttrs.version}/Ubuntu/x86_64/Synology%20Chat%20Client-${finalAttrs.version}.deb";
    # sha512 can be obtained from Arch AUR, converted using
    # $ nix hash convert --from base16 --hash-algo sha512 --to sri <hash>
    hash = "sha512-+UEX74s7spnZb7zm97gCrhjNQ2F2UC6hOGTHnMCGFpZxrGFUkB0/165X3hHd+hd9S/FIrpm70zlj4+xTF/Lk7w==";
  };

  binary = "$out/opt/Synology\\ Chat/synochat";

  nativeBuildInputs = [
    dpkg
    makeWrapper
    patchelf
    autoPatchelfHook
  ];

  runtimeInputs = [
    lsb-release
    xdg-utils
    xdg-user-dirs
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -R opt usr/share $out/
    substituteInPlace $out/share/applications/synochat.desktop \
      --replace-fail 'Exec="/opt/Synology Chat/synochat"' "Exec=synochat"
    # fix the path in the desktop file
    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${finalAttrs.binary} $out/bin/synochat \
     --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs}:$out/opt/Synology\ Chat \
     --prefix PATH : ${lib.makeBinPath finalAttrs.runtimeInputs} \
     --add-flags "$out/opt/Synology Chat/resources/app.asar"
  '';
  buildInputs = [
    stdenv.cc.cc
    stdenv.cc.cc.lib
    alsa-lib
    nss
    libdrm
    mesa
    glib
    nspr
    atk
    cups
    dbus
    gtk3
    pango
    cairo
    gdk-pixbuf
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb
    xorg.libXtst
    expat
    libxkbcommon
    gnome.gvfs
    harfbuzzFull
    udev
  ];
  meta = {
    description = "Synology NAS Chat application";
    homepage = "https://www.synology.com/en-us/dsm/feature/chat";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.shimun ];
    mainProgram = "synochat";
  };
})
