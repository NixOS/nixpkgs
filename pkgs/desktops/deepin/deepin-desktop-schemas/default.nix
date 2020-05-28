{ stdenv
, fetchFromGitHub
, python3
, go
, go-lib
, dconf
, glib
, deepin-gtk-theme
, deepin-icon-theme
, deepin-sound-theme
, deepin-wallpapers
, deepin
}:

stdenv.mkDerivation rec {
  pname = "deepin-desktop-schemas";
  version = "5.8.0.5";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "120fs6ca7znq79gjifa54j119b9bzlpann61mk2bxjl7bbcjw1na";
  };

  nativeBuildInputs = [
    python3
    go
    go-lib
    glib.dev
    deepin.setupHook
  ];

  buildInputs = [
    dconf
    deepin-gtk-theme
    deepin-icon-theme
    deepin-sound-theme
    deepin-wallpapers
  ];

  postPatch = ''
    searchHardCodedPaths

    # fix default background url
    sed -i -e 's,/usr/share/backgrounds/default_background.jpg,/usr/share/backgrounds/deepin/desktop.jpg,' \
      overrides/common/com.deepin.wrap.gnome.desktop.override \
      schemas/com.deepin.dde.appearance.gschema.xml

    fixPath ${deepin-wallpapers} /usr/share/backgrounds \
      overrides/common/com.deepin.wrap.gnome.desktop.override \
      schemas/com.deepin.dde.appearance.gschema.xml

    substituteInPlace schemas/wrap/com.deepin.wrap.gnome.desktop.app-folders.gschema.xml \
      --replace /usr/share/desktop-directories \
                /run/current-system/sw/share/desktop-directories

    # still hardcoded paths:
    #   /etc/gnome-settings-daemon/xrandr/monitors.xml                                ? gnome3.gnome-settings-daemon
    #   /opt/google/chrome/chrome
    #   /usr/share/backgrounds/gnome/adwaita-lock.jpg                                 ? gnome3.gnome-backgrounds
    #   /usr/share/backgrounds/gnome/adwaita-timed.xml                                gnome3.gnome-backgrounds
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  preBuild = ''
    export GOPATH="$GOPATH:${go-lib}/share/go"
    export GOCACHE=$TMPDIR/go-cache
  '';

  doCheck = true;
  checkTarget = "test";

  postInstall = ''
    glib-compile-schemas --strict $out/share/glib-2.0/schemas
  '';

  postFixup = ''
    searchHardCodedPaths $out
  '';

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "GSettings deepin desktop-wide schemas";
    homepage = "https://github.com/linuxdeepin/deepin-desktop-schemas";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
