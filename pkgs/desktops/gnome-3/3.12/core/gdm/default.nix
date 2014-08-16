{ stdenv, fetchurl, pkgconfig, glib, itstool, libxml2, xorg, dbus
, intltool, accountsservice, libX11, gnome3, systemd, gnome_session
, gtk, libcanberra_gtk3, pam, libtool, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "gdm-3.12.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gdm/3.12/${name}.tar.xz";
    sha256 = "cc91fff5afd2a7c3e712c960a0b60744774167dcfc16f486372e1eb3c0aa1cc4";
  };

  # Only needed to make it build
  preConfigure = ''
    substituteInPlace ./configure --replace "/usr/bin/X" "${xorg.xorgserver}/bin/X"
  '';

  configureFlags = [ "--localstatedir=/var" "--with-systemd=yes"
                     "--with-systemdsystemunitdir=$(out)/etc/systemd/system" ];

  buildInputs = [ pkgconfig glib itstool libxml2 intltool
                  accountsservice gnome3.dconf systemd
                  gobjectIntrospection libX11 gtk
                  libcanberra_gtk3 pam libtool ];

  enableParallelBuilding = true;

  preBuild = ''
    substituteInPlace daemon/gdm-simple-slave.c --replace 'BINDIR "/gnome-session' '"${gnome_session}/bin/gnome-session'
    substituteInPlace daemon/gdm-launch-environment.c --replace 'BINDIR "/dbus-launch' '"${dbus.tools}/bin/dbus-launch'
  '';

  # Disable Access Control because our X does not support FamilyServerInterpreted yet
  patches = [ ./xserver_path.patch ./sessions_dir.patch ./disable_x_access_control.patch ./propagate_xdgconfigdirs.patch ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GDM;
    description = "A program that manages graphical display servers and handles graphical user logins";
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };
}
