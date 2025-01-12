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
  version = "2.7-prerelease-2";

  src = fetchurl {
    url = "https://github.com/kingToolbox/WindTerm/releases/download/${version}/WindTerm_2.7.0_Prerelease_2_Linux_Portable_x86_64.tar.gz";
    hash = "sha256-ZIFA3ASa3vQd1zr+8v4bA18NxGumNKP7f0cEzJVANEg=";
  };

  nativeBuildInputs = [
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
    install -Dm644 $out/app/windterm/windterm.desktop $out/share/applications/windterm.desktop
    install -Dm644 $out/app/windterm/windterm.png $out/share/pixmaps/windterm.png
    substituteInPlace $out/share/applications/windterm.desktop \
      --replace-fail "/usr/bin/" ""
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
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ aucub ];
  };
}
