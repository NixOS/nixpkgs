{ stdenv, fetchurl, pkgconfig, glib, itstool, libxml2, xorg, dbus
, intltool, accountsservice, libX11, gnome3, systemd, gnome_session
, gtk, libcanberra_gtk3, pam, libtool, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "gdm-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gdm/${gnome3.version}/${name}.tar.xz";
    sha256 = "ed83498131bcea69ce60f882783c669c24b007d2b7e1219b4bdde18f6c94deb1";
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

  #enableParallelBuilding = true; # problems compiling

  preBuild = ''
    substituteInPlace daemon/gdm-simple-slave.c --replace 'BINDIR "/gnome-session' '"${gnome_session}/bin/gnome-session'
    substituteInPlace daemon/gdm-launch-environment.c --replace 'BINDIR "/dbus-launch' '"${dbus.tools}/bin/dbus-launch'
  '';

  # Disable Access Control because our X does not support FamilyServerInterpreted yet
  # Propagate more environment variables: https://bugzilla.gnome.org/show_bug.cgi?id=740632
  patches = [ ./xserver_path.patch ./sessions_dir.patch ./disable_x_access_control.patch ./propagate_env.patch ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GDM;
    description = "A program that manages graphical display servers and handles graphical user logins";
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };
}
