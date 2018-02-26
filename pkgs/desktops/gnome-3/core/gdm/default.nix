{ stdenv, fetchurl, pkgconfig, glib, itstool, libxml2, xorg, dbus
, intltool, accountsservice, libX11, gnome3, systemd, autoreconfHook
, gtk, libcanberra-gtk3, pam, libtool, gobjectIntrospection, plymouth
, librsvg, coreutils }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  # Only needed to make it build
  preConfigure = ''
    substituteInPlace ./configure --replace "/usr/bin/X" "${xorg.xorgserver.out}/bin/X"
  '';

  postPatch = ''
    substituteInPlace daemon/gdm-manager.c --replace "/bin/plymouth" "${plymouth}/bin/plymouth"
    substituteInPlace data/gdm.service.in  --replace "/bin/kill" "${coreutils}/bin/kill"
  '';

  configureFlags = [ "--sysconfdir=/etc"
                     "--localstatedir=/var"
                     "--with-plymouth=yes"
                     "--with-initial-vt=7"
                     "--with-systemdsystemunitdir=$(out)/etc/systemd/system" ];

  nativeBuildInputs = [ pkgconfig libxml2 itstool intltool autoreconfHook libtool gnome3.dconf ];
  buildInputs = [ glib accountsservice systemd
                  gobjectIntrospection libX11 gtk
                  libcanberra-gtk3 pam plymouth librsvg ];

  enableParallelBuilding = true;

  # Disable Access Control because our X does not support FamilyServerInterpreted yet
  patches = [ ./sessions_dir.patch
              ./gdm-x-session_extra_args.patch
              ./gdm-session-worker_xserver-path.patch
             ];

  postInstall = ''
    # Prevent “Could not parse desktop file orca-autostart.desktop or it references a not found TryExec binary”
    rm $out/share/gdm/greeter/autostart/orca-autostart.desktop
  '';

  installFlags = [ "sysconfdir=$(out)/etc" "dbusconfdir=$(out)/etc/dbus-1/system.d" ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GDM;
    description = "A program that manages graphical display servers and handles graphical user logins";
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
