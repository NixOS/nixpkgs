{ stdenv
, fetchurl
, fetchpatch
, autoreconfHook
, intltool
, itstool
, libxml2
, libxslt
, pkgconfig
, gnome-panel
, gtk3
, glib
, libwnck3
, libgtop
, libnotify
, upower
, dbus-glib
, wirelesstools
, linuxPackages
, adwaita-icon-theme
, libgweather
, gucharmap
, gnome-settings-daemon
, tracker
, polkit
, gnome3
}:

let
  pname = "gnome-applets";
  version = "3.28.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0wd6pirv57rcxm5d32r1s3ni7sp26gnqd4qhjciw0pn5ak627y5h";
  };

  patches = [
    # https://github.com/NixOS/nixpkgs/issues/36468
    # https://gitlab.gnome.org/GNOME/gnome-applets/issues/3
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/gnome-applets/commit/1ee719581c33d7d640ae9f656e4e9b192bafef78.patch;
      sha256 = "05wim7d2ii3pxph3n3am76cvnxmkfpggk0cpy8p5xgm3hcibwfrf";
    })
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/gnome-applets/commit/1fa778b01f0e6b70678b0e5755ca0ed7a093fa75.patch;
      sha256 = "0kppqywn0ab18p64ixz0b58cn5bpqf0xy71bycldlc5ybpdx5mq0";
    })

    # https://gitlab.gnome.org/GNOME/gnome-applets/issues/4
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/gnome-applets/commit/e14482a90e6113f211e9328d8c39a69bdf5111d8.patch;
      sha256 = "10ac0kk38hxqh8yvdlriyyv809qrxbpy9ihp01gizhiw7qpz97ff";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    intltool
    itstool
    pkgconfig
    libxml2
    libxslt
  ];

  buildInputs = [
    gnome-panel
    gtk3
    glib
    libxml2
    libwnck3
    libgtop
    libnotify
    upower
    dbus-glib
    adwaita-icon-theme
    libgweather
    gucharmap
    gnome-settings-daemon
    tracker
    polkit
    wirelesstools
    linuxPackages.cpupower
  ];

  enableParallelBuilding = true;

  doCheck = true;

  configureFlags = [
    "--with-libpanel-applet-dir=$(out)/share/gnome-panel/applets"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "Applets for use with the GNOME panel";
    homepage = https://wiki.gnome.org/Projects/GnomeApplets;
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
