{ stdenv, fetchFromGitHub, python3, gnome3, glib, deepin-gtk-theme,
  deepin-icon-theme, deepin-sound-theme, deepin-wallpapers, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-desktop-schemas";
  version = "3.13.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0bamjcpmsl8xhw3ksgl11wv5xwcdhrkl1namikfzc4an03sk1rdq";
  };

  nativeBuildInputs = [
    python3
    glib.dev
    deepin.setupHook
  ];

  buildInputs = [
    gnome3.dconf
    deepin-gtk-theme
    deepin-icon-theme
    deepin-sound-theme
    deepin-wallpapers
  ];

  postPatch = ''
    searchHardCodedPaths

    # fix default background url
    sed -i -e 's,/usr/share/backgrounds/default_background.jpg,/usr/share/backgrounds/deepin/desktop.jpg,' \
      overrides/common/com.deepin.wrap.gnome.desktop.override
      
    fixPath ${deepin-wallpapers} /usr/share/backgrounds \
      overrides/common/com.deepin.wrap.gnome.desktop.override

    fixPath ${deepin-wallpapers} /usr/share/wallpapers/deepin \
      schemas/com.deepin.dde.appearance.gschema.xml

    # still hardcoded paths:
    #   /etc/gnome-settings-daemon/xrandr/monitors.xml                                ? gnome3.gnome-settings-daemon
    #   /usr/share/backgrounds/gnome/adwaita-lock.jpg                                 ? gnome3.gnome-backgrounds
    #   /usr/share/backgrounds/gnome/adwaita-timed.xml                                gnome3.gnome-backgrounds
    #   /usr/share/desktop-directories
  '';

  makeFlags = [ "PREFIX=${placeholder ''out''}" ];

  doCheck = true;
  checkTarget = "test";

  postInstall = ''
    glib-compile-schemas --strict $out/share/glib-2.0/schemas
    searchHardCodedPaths $out
  '';

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "GSettings deepin desktop-wide schemas";
    homepage = https://github.com/linuxdeepin/deepin-desktop-schemas;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
