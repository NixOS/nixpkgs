{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  ffmpeg,
  glib,
  gtk3,
  wrapGAppsHook3,
  nss,
  xdg-utils,
  nspr,
  libgbm,
  systemd,
  libglvnd,
  libGL,
  libGLU,
}:

stdenv.mkDerivation rec {
  pname = "zoho-mail";
  version = "1.6.6";

  src = fetchurl {
    url = "https://downloads.zohocdn.com/zmail-desktop/linux/zoho-mail-desktop-lite-installer-x64-v${version}.deb";
    hash = "sha256-iZJZqJ2f5YfiDvmp+H3e7bH/LcJtfZndqcdjVCzBAXw=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook3
    dpkg
  ];

  dontWrapGApps = true;

  buildInputs = [
    ffmpeg
    glib
    gtk3
    nss
    xdg-utils
    nspr
    libgbm
    libglvnd
    libGL
    libGLU
  ];

  runtimeDependencies = buildInputs ++ [ systemd ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin/
    dpkg -x $src $out/
    ln -s "$out/opt/Zoho Mail - Desktop/zoho-mail-desktop" $out/bin/zoho-mail-desktop
    mv $out/usr/share $out/
    rmdir $out/usr
    substituteInPlace $out/share/applications/zoho-mail-desktop.desktop \
      --replace-fail 'Exec="/opt/Zoho Mail - Desktop/zoho-mail-desktop" %U' 'Exec=zoho-mail-desktop %U'
    runHook postInstall
  '';

  meta = with lib; {
    description = "Zoho Mail Desktop Lite client";
    homepage = "https://www.zoho.com/mail/desktop";
    license = licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ pahofmann ];
    mainProgram = "zoho-mail-desktop";
    platforms = [ "x86_64-linux" ];
  };
}
