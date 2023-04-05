{ lib, stdenv, pkg-config, fetchFromGitHub, python3, vala
, gtk3, libwnck, libxfce4util, xfce4-panel, wafHook, xfce
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "xfce4-namebar-plugin";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "HugLifeTiZ";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aKrJzf9rwCyXAJsRIXdBzmJBASuXD5I5kZrp+atx4FA=";
  };

  nativeBuildInputs = [ pkg-config vala wafHook python3 ];
  buildInputs = [ gtk3 libwnck libxfce4util xfce4-panel ];

  postPatch = ''
    substituteInPlace src/namebar.vala --replace 'var dirs = Environment.get_system_data_dirs()' "string[] dirs = { \"$out/share\" }"
    substituteInPlace src/preferences.vala --replace 'var dir_strings = Environment.get_system_data_dirs()' "string[] dir_strings = { \"$out/share\" }"
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    homepage = "https://github.com/HugLifeTiZ/xfce4-namebar-plugin";
    description = "Plugin which integrates titlebar and window controls into the xfce4-panel";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
    # Does not build with vala 0.48 or later
    # libxfce4panel-2.0.vapi:92.3-92.41: error: overriding method `Xfce.PanelPlugin.remote_event' is incompatible
    # with base method `bool Xfce.PanelPluginProvider.remote_event (string, GLib.Value, uint)': too few parameters.
    #               public virtual signal bool remote_event (string name, GLib.Value value);
    #               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    # Upstream has no activity since 20 May 2020
    broken = true;
  };
}
