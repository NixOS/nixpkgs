{ stdenv, fetchFromGitHub, pkgconfig, intltool, libtool, gnome3, xorg,
  libcanberra-gtk3, upower, xkeyboard_config, libxkbcommon,
  libstartup_notification, libinput, cogl, clutter, systemd
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-mutter";
  version = "3.20.34";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0s427fmj806ljpdg6jdvpfislk5m1xvxpnnyrq3l8b7pkhjvp8wd";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    libtool
    gnome3.gnome-common
  ];

  buildInputs = [
    gnome3.gtk
    gnome3.gnome-desktop
    gnome3.gsettings-desktop-schemas
    gnome3.libgudev
    gnome3.zenity
    upower
    xorg.libxkbfile
    libxkbcommon
    libcanberra-gtk3
    libstartup_notification
    libinput
    xkeyboard_config
    cogl
    clutter
    systemd
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--enable-native-backend"
    "--enable-compile-warnings=minimum"
  ];

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  meta = with stdenv.lib; {
    description = "Base window manager for deepin, fork of gnome mutter";
    homepage = https://github.com/linuxdeepin/deepin-mutter;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
