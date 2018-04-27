{ stdenv, fetchurl, substituteAll, pkgconfig, glib, itstool, libxml2, xorg, dbus
, intltool, accountsservice, libX11, gnome3, systemd, autoreconfHook
, gtk, libcanberra-gtk3, pam, libtool, gobjectIntrospection, plymouth
, librsvg, coreutils }:

stdenv.mkDerivation rec {
  name = "gdm-${version}";
  version = "3.28.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gdm/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1yxjjyrp0ywrc25cp81bsdhp79zn0c0jag48hlp00b5wfnkqy1kp";
  };

  # Only needed to make it build
  preConfigure = ''
    substituteInPlace ./configure --replace "/usr/bin/X" "${xorg.xorgserver.out}/bin/X"
  '';

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-plymouth=yes"
    "--with-initial-vt=7"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
  ];

  nativeBuildInputs = [ pkgconfig libxml2 itstool intltool autoreconfHook libtool gnome3.dconf ];
  buildInputs = [
    glib accountsservice systemd
    gobjectIntrospection libX11 gtk
    libcanberra-gtk3 pam plymouth librsvg
  ];

  enableParallelBuilding = true;

  # Disable Access Control because our X does not support FamilyServerInterpreted yet
  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit coreutils plymouth;
    })
    ./sessions_dir.patch
    ./gdm-x-session_extra_args.patch
    ./gdm-session-worker_xserver-path.patch
  ];

  installFlags = [
    "sysconfdir=$(out)/etc"
    "dbusconfdir=$(out)/etc/dbus-1/system.d"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gdm";
      attrPath = "gnome3.gdm";
    };
  };

  meta = with stdenv.lib; {
    description = "A program that manages graphical display servers and handles graphical user logins";
    homepage = https://wiki.gnome.org/Projects/GDM;
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
