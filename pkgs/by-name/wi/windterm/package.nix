{
  lib,
  stdenv,
  fetchurl,
  unzip,
  autoPatchelfHook,
  fontconfig,
  freetype,
  libGL,
  glib,
  alsa-lib,
  pulseaudio,
  xorg,
  gtk3,
  atk,
  pango,
  gdk-pixbuf,
  cairo,
  gst_all_1,
  makeWrapper,
  libsForQt5,
  profiles ? {
    path = "~";
  },
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "windterm";
  version = "2.7.0";

  src = fetchurl {
    url = "https://github.com/kingToolbox/WindTerm/releases/download/${finalAttrs.version}/WindTerm_${finalAttrs.version}_Linux_Portable_x86_64.zip";
    hash = "sha256-d5dpfutgI5AgUS4rVJaVpgw5s/0B/n67BH/VCiiJEDw=";
  };

  nativeBuildInputs = [
    unzip
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    xorg.libxcb
    xorg.xcbutil
    xorg.libXtst
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    libsForQt5.qtbase
    libsForQt5.qtmultimedia
    gst_all_1.gst-plugins-base
    fontconfig
    freetype
    libGL
    glib
    alsa-lib
    pulseaudio
    gtk3
    atk
    pango
    gdk-pixbuf
    cairo
    (lib.getLib stdenv.cc.cc)
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/app $out/share/applications $out/share/pixmaps $out/share/licenses/windterm
    cp --recursive --no-preserve=mode . $out/app/windterm
    cat > $out/app/windterm/profiles.config <<EOF
    ${builtins.toJSON profiles}
    EOF
    install -Dm644 $out/app/windterm/license.txt $out/share/licenses/windterm/license.txt
    install -Dm644 $out/app/windterm/windterm.png $out/share/pixmaps/windterm.png
    substituteInPlace $out/app/windterm/windterm.desktop \
      --replace-fail "/usr/bin/" ""
    install -Dm644 $out/app/windterm/windterm.desktop $out/share/applications/windterm.desktop
    chmod +x $out/app/windterm/WindTerm

    runHook postInstall
  '';

  dontWrapQtApps = true;

  postFixup = ''
    mkdir $out/bin
    makeWrapper $out/app/windterm/WindTerm $out/bin/windterm \
      --prefix QT_PLUGIN_PATH : $out/app/windterm/lib \
      ''${qtWrapperArgs[@]}
  '';

  meta = {
    description = "Professional cross-platform SSH/Sftp/Shell/Telnet/Serial terminal";
    homepage = "https://github.com/kingToolbox/WindTerm";
    mainProgram = "windterm";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
})
