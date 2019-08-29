{ stdenv, fetchFromGitHub, pkgconfig, intltool, libtool, gnome3, gtk3,
  xorg, libcanberra-gtk3, upower, xkeyboard_config, libxkbcommon,
  libstartup_notification, libinput, libgudev, cogl, clutter, systemd,
  gsettings-desktop-schemas, deepin-desktop-schemas, wrapGAppsHook,
  deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-mutter";
  version = "3.20.38";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1aq7606sgn2c6n8wfgxdryw3lprc4va0zjc0r65798w5656fdi31";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    libtool
    gnome3.gnome-common
    wrapGAppsHook
    deepin.setupHook
  ];

  buildInputs = [
    clutter
    cogl
    deepin-desktop-schemas
    gnome3.gnome-desktop
    gnome3.zenity
    gsettings-desktop-schemas
    gtk3
    libcanberra-gtk3
    libgudev
    libinput
    libstartup_notification
    libxkbcommon
    systemd
    upower
    xkeyboard_config
    xorg.libxkbfile
  ];

  patches = [
    ./deepin-mutter.plugins-dir.patch
  ];

  postPatch = ''
    searchHardCodedPaths  # debugging
    sed -i -e "s,Exec=deepin-mutter,Exec=$out/bin/deepin-mutter," data/mutter.desktop.in
  '';

  configureFlags = [
    "--enable-native-backend"
    "--enable-compile-warnings=minimum"
  ];

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  postFixup = ''
    searchHardCodedPaths $out  # debugging
  '';

  enableParallelBuilding = true;

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Base window manager for deepin, fork of gnome mutter";
    homepage = https://github.com/linuxdeepin/deepin-mutter;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
