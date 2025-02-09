{ stdenv
, mate
, glib
, wrapGAppsHook
}:

stdenv.mkDerivation {
  pname = "${mate.mate-settings-daemon.pname}-wrapped";
  version = mate.mate-settings-daemon.version;

  nativeBuildInputs = [
    wrapGAppsHook
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
  '';

  postFixup = ''
    mkdir -p $out/libexec
    makeWrapper ${mate.mate-settings-daemon}/libexec/mate-settings-daemon $out/libexec/mate-settings-daemon \
      "''${gappsWrapperArgs[@]}"
    substituteInPlace $out/etc/xdg/autostart/mate-settings-daemon.desktop \
      --replace "${mate.mate-settings-daemon}/libexec/mate-settings-daemon" "$out/libexec/mate-settings-daemon"
  '';

  meta = mate.mate-settings-daemon.meta // { priority = -10; };
}
