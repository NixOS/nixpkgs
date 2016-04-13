{ stdenv, fetchurl, pkgconfig, glib, itstool, libxml2, xorg, dbus
, intltool, accountsservice, libX11, gnome3, systemd, gnome_session
, gtk, libcanberra_gtk3, pam, libtool, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "gdm-${gnome3.version}.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gdm/${gnome3.version}/${name}.tar.xz";
    sha256 = "0mhv3q8z208qvhz00zrxlqn7w9gi5vy6w8dpjh5s2ka28l3yhbn3";
  };

  preConfigure = ''
    substituteInPlace ./configure --replace "/usr/bin/X" "${xorg.xorgserver.out}/bin/X"
    substituteInPlace daemon/gdm-simple-slave.c --replace 'BINDIR "/gnome-session' '"${gnome_session}/bin/gnome-session'
    substituteInPlace daemon/gdm-launch-environment.c --replace 'BINDIR "/dbus-launch' '"${dbus.dbus-launch}'
    substituteInPlace data/gdm.conf-custom.in --replace '#WaylandEnable=false' 'WaylandEnable=false'
    sed 's/#Enable=true/Enable=true/' -i data/gdm.conf-custom.in
 '';

  configureFlags = [ "--localstatedir=/var" "--with-systemd=yes" "--without-plymouth"
                     "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
                     "--with-initial-vt=10" ];

  buildInputs = [ pkgconfig glib itstool libxml2 intltool
                  accountsservice gnome3.dconf systemd
                  gobjectIntrospection libX11 gtk
                  libcanberra_gtk3 pam libtool ];

  #enableParallelBuilding = true; # problems compiling

  # Disable Access Control because our X does not support FamilyServerInterpreted yet
  patches = [ ./xserver_path.patch ./sessions_dir.patch ./disable_x_access_control.patch ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GDM;
    description = "A program that manages graphical display servers and handles graphical user logins";
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
