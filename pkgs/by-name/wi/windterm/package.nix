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
  qt5,
  xorg,
  gtk3,
  atk,
  pango,
  gdk-pixbuf,
  cairo,
  gst_all_1,
  makeWrapper,
  profiles ? {
    path = "~";
  },
}:
let
  version = "2.6.1";
  src = fetchurl {
    url = "https://github.com/kingToolbox/WindTerm/releases/download/2.6.0/WindTerm_${version}_Linux_Portable_x86_64.tar.gz";
    hash = "sha256-JwTsfUkESl2vUx48TanKYAOVWw6q4xGY+i0PrN9GfpA=";
  };
in
stdenv.mkDerivation {
  inherit version src;

  pname = "windterm";

  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
    qt5.wrapQtAppsHook
    autoPatchelfHook
  ];

  buildInputs = [
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
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/windterm/ $out/bin/ $out/share/applications/ $out/share/pixmaps/
    cp -r ./* $out/windterm/
    chmod 755 $out/windterm/
    cat > $out/windterm/profiles.config <<EOF
    ${builtins.toJSON profiles}
    EOF
    find $out/windterm -type f -exec chmod 644 {} +
    find $out/windterm -type d -exec chmod 755 {} +
    chmod +x $out/windterm/WindTerm
    install -Dm0644 $out/windterm/windterm.desktop $out/share/applications/windterm.desktop
    install -Dm0644 $out/windterm/windterm.png $out/share/pixmaps/windterm.png
    substituteInPlace $out/share/applications/windterm.desktop \
      --replace-fail 'Exec=/usr/bin/windterm' 'Exec=windterm'

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/windterm/WindTerm $out/bin/windterm
  '';

  meta = {
    description = "Professional cross-platform SSH/Sftp/Shell/Telnet/Serial terminal";
    homepage = "https://github.com/kingToolbox/WindTerm";
    mainProgram = "windterm";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.darwin ++ [ "x86_64-linux" ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
