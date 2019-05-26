{ makeWrapper, symlinkJoin, dde-dock, plugins }:

symlinkJoin {
  name = "dde-dock-with-plugins-${dde-dock.version}";

  paths = [ dde-dock ] ++ plugins;

  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/dde-dock \
      --set DDE_DOCK_PLUGINS_DIR "$out/lib/dde-dock/plugins"

    rm $out/share/dbus-1/services/com.deepin.dde.Dock.service

    substitute ${dde-dock}/share/dbus-1/services/com.deepin.dde.Dock.service $out/share/dbus-1/services/com.deepin.dde.Dock.service \
      --replace ${dde-dock} $out
  '';

  inherit (dde-dock) meta;
}
