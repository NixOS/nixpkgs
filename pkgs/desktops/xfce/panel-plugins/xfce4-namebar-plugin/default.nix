{ lib, stdenv, pkg-config, fetchFromGitHub, python3, vala_0_46
, gtk3, libwnck, libxfce4util, xfce4-panel, wafHook, xfce }:

stdenv.mkDerivation rec {
  pname = "xfce4-namebar-plugin";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "HugLifeTiZ";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aKrJzf9rwCyXAJsRIXdBzmJBASuXD5I5kZrp+atx4FA=";
  };

  nativeBuildInputs = [ pkg-config vala_0_46 wafHook python3 ];
  buildInputs = [ gtk3 libwnck libxfce4util xfce4-panel ];

  postPatch = ''
    substituteInPlace src/namebar.vala --replace 'var dirs = Environment.get_system_data_dirs()' "string[] dirs = { \"$out/share\" }"
    substituteInPlace src/preferences.vala --replace 'var dir_strings = Environment.get_system_data_dirs()' "string[] dir_strings = { \"$out/share\" }"
  '';

  passthru.updateScript = xfce.updateScript {
    inherit pname version;
    attrPath = "xfce.${pname}";
    versionLister = xfce.gitLister src.meta.homepage;
    rev-prefix = "v";
  };

  meta = with lib; {
    homepage = "https://github.com/HugLifeTiZ/xfce4-namebar-plugin";
    description = "Plugin which integrates titlebar and window controls into the xfce4-panel";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.volth ];
  };
}
