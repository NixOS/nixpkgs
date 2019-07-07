{ stdenv, pkgconfig, fetchFromGitHub, python2, vala_0_40
, gtk2, libwnck, libxfce4util, xfce4-panel, wafHook }:

stdenv.mkDerivation rec {
  ver = "0.3.1";
  rev = "07a23b3";
  name = "xfce4-namebar-plugin-${ver}";

  src = fetchFromGitHub {
    owner = "TiZ-EX1";
    repo = "xfce4-namebar-plugin";
    rev = rev;
    sha256 = "1sl4qmjywfvv53ch7hyfysjfd91zl38y7gdw2y3k69vkzd3h18ad";
  };

  nativeBuildInputs = [ pkgconfig wafHook ];
  buildInputs = [ python2 vala_0_40 gtk2 libwnck libxfce4util xfce4-panel ];

  postPatch = ''
    substituteInPlace src/preferences.vala --replace 'Environment.get_system_data_dirs()' "{ \"$out/share\" }"
    substituteInPlace src/namebar.vala     --replace 'Environment.get_system_data_dirs()' "{ \"$out/share\" }"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/TiZ-EX1/xfce4-namebar-plugin;
    description = "A plugins which integrates titlebar and window controls into the xfce4-panel";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.volth ];
  };
}
