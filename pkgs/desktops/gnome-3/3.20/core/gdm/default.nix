{ stdenv, fetchurl, pkgconfig, glib, itstool, libxml2, xorg, dbus
, intltool, accountsservice, libX11, gnome3, systemd, gnome_session, autoreconfHook
, gtk, libcanberra_gtk3, pam, libtool, gobjectIntrospection, plymouth }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  # Only needed to make it build
  preConfigure = ''
    substituteInPlace ./configure --replace "/usr/bin/X" "${xorg.xorgserver.out}/bin/X"
  '';

  configureFlags = [ "--sysconfdir=/etc"
                     "--localstatedir=/var"
                     "--with-systemd=yes"
                     "--with-plymouth=yes"
                     "--with-systemdsystemunitdir=$(out)/etc/systemd/system" ];

  buildInputs = [ pkgconfig glib itstool libxml2 intltool autoreconfHook
                  accountsservice gnome3.dconf systemd
                  gobjectIntrospection libX11 gtk
                  libcanberra_gtk3 pam libtool plymouth ];

  #enableParallelBuilding = true; # problems compiling

  preBuild = ''
    substituteInPlace daemon/gdm-simple-slave.c --replace 'BINDIR "/gnome-session' '"${gnome_session}/bin/gnome-session'
  '';

  # Disable Access Control because our X does not support FamilyServerInterpreted yet
  patches = [ ./xserver_path.patch ./sessions_dir.patch
              ./disable_x_access_control.patch ./no-dbus-launch.patch
              ./libsystemd.patch ];

  installFlags = [ "sysconfdir=$(out)/etc" "dbusconfdir=$(out)/etc/dbus-1/system.d" ];

  postInstall = ''
    mv $out/share/gdm/greeter/applications/gnome-shell.desktop $out/share/gdm/greeter/applications/org.gnome.Shell.desktop
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GDM;
    description = "A program that manages graphical display servers and handles graphical user logins";
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
