{
  lib,
  stdenv,
  fetchurl,
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
stdenv.mkDerivation rec {
  pname = "windterm";
  version = "2.6.1";

  src = fetchurl {
    url = "https://github.com/kingToolbox/WindTerm/releases/download/2.6.0/WindTerm_${version}_Linux_Portable_x86_64.tar.gz";
    hash = "sha256-JwTsfUkESl2vUx48TanKYAOVWw6q4xGY+i0PrN9GfpA=";
  };

  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    xorg.libxcb
    xorg.xcbutil
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    libsForQt5.qt5.qtbase
    libsForQt5.qt5.qtmultimedia
    fontconfig
    freetype
    libGL
    glib
    alsa-lib
    pulseaudio
    gst_all_1.gst-plugins-base
    xorg.libXtst
    gtk3
    atk
    pango
    gdk-pixbuf
    cairo
    (lib.getLib stdenv.cc.cc)
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r ./* $out/
    find $out -type d -exec chmod 755 {} \;
    find $out -type f -exec chmod 644 {} \;
    find $out -type f -executable -exec chmod 755 {} \;
    chmod 755 $out/WindTerm
    mkdir -p $out/bin/ $out/share/applications/ $out/share/pixmaps/ $out/share/licenses/${pname}/
    cat > $out/profiles.config <<EOF
    ${builtins.toJSON profiles}
    EOF
    mv $out/license.txt $out/share/licenses/${pname}/license.txt
    mv $out/windterm.desktop $out/share/applications/windterm.desktop
    mv $out/windterm.png $out/share/pixmaps/windterm.png
    substituteInPlace $out/share/applications/windterm.desktop \
      --replace-fail "Exec=/usr/bin/windterm" "Exec=windterm"

    runHook postInstall
  '';

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapper $out/WindTerm $out/bin/windterm \
      --prefix QT_PLUGIN_PATH : "$out/lib" \
      ''${qtWrapperArgs[@]}
  '';

  meta = {
    description = "Professional cross-platform SSH/Sftp/Shell/Telnet/Serial terminal";
    homepage = "https://github.com/kingToolbox/WindTerm";
    mainProgram = "windterm";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ aucub ];
    platforms = [ "x86_64-linux" ];
  };
}
