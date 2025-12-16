{
  stdenv,
  mate,
  glib,
  wrapGAppsHook3,
}:

stdenv.mkDerivation {
  pname = "${mate.mate-settings-daemon.pname}-wrapped";
  inherit (mate.mate-settings-daemon) version outputs;

  nativeBuildInputs = [
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    mate.mate-control-center
  ];

  dontWrapGApps = true;

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/etc/xdg/autostart
    cp ${mate.mate-settings-daemon}/etc/xdg/autostart/mate-settings-daemon.desktop $out/etc/xdg/autostart

    mkdir -p $out/share/man
    cp -r ${mate.mate-settings-daemon.man}/share/man/* $out/share/man/
  '';

  postFixup = ''
    mkdir -p $out/libexec
    makeWrapper ${mate.mate-settings-daemon}/libexec/mate-settings-daemon $out/libexec/mate-settings-daemon \
      "''${gappsWrapperArgs[@]}"
    substituteInPlace $out/etc/xdg/autostart/mate-settings-daemon.desktop \
      --replace-fail "${mate.mate-settings-daemon}/libexec/mate-settings-daemon" "$out/libexec/mate-settings-daemon"
  '';

  meta = mate.mate-settings-daemon.meta // {
    priority = -10;
  };
}
