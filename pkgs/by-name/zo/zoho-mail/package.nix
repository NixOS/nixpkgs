{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  ffmpeg-full,
  glib,
  gtk3,
  wrapGAppsHook3,
  nss,
  xdg-utils,
  nspr,
  mesa,
  systemd,
  libglvnd,
  libGL,
  libGLU,
}:

stdenv.mkDerivation rec {
  pname = "zoho-mail";
  version = "1.6.5";

  src = fetchurl {
    url = "https://downloads.zohocdn.com/zmail-desktop/linux/zoho-mail-desktop-lite-installer-x64-v${version}.deb";
    hash = "sha256-03jahxpn4lf7i8923v2wr3zahp7cw1s0l9ikivxbfxgighyabpa6";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook3
  ];

  dontWrapGApps = true;

  buildInputs = [
    dpkg
    ffmpeg-full
    glib
    gtk3
    nss
    xdg-utils
    nspr
    mesa
    libglvnd
    libGL
    libGLU
  ];

  runtimeDependencies = buildInputs ++ [ systemd ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin/
    dpkg -x $src $out/bin/
    cd $out
    runHook postInstall
  '';

  meta = with lib; {
    description = "Zoho Mail Desktop Lite client";
    homepage = "https://www.zoho.com/mail/desktop";
    license = licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ pahofmann ];
    platforms = [ "x86_64-linux" ];
  };
}
