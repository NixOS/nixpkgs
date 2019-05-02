{ stdenv, fetchurl, substituteAll, pkgconfig, glib, itstool, libxml2, xorg
, accountsservice, libX11, gnome3, systemd, autoreconfHook
, gtk3, libcanberra-gtk3, pam, libtool, gobject-introspection, plymouth
, librsvg, coreutils, xwayland, fetchpatch }:

stdenv.mkDerivation rec {
  name = "gdm-${version}";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gdm/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "12ypdz9i24hwbl1d1wnnxb8zlvfa4f49n9ac5cl9d6h8qp4b0gb4";
  };

  # Only needed to make it build
  preConfigure = ''
    substituteInPlace ./configure --replace "/usr/bin/X" "${xorg.xorgserver.out}/bin/X"
  '';

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-plymouth=yes"
    "--enable-gdm-xsession"
    "--with-initial-vt=7"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    "--with-udevdir=$(out)/lib/udev"
  ];

  nativeBuildInputs = [ pkgconfig libxml2 itstool autoreconfHook libtool gnome3.dconf ];
  buildInputs = [
    glib accountsservice systemd
    gobject-introspection libX11 gtk3
    libcanberra-gtk3 pam plymouth librsvg
  ];

  enableParallelBuilding = true;

  patches = [
    # Change hardcoded paths to nix store paths.
    (substituteAll {
      src = ./fix-paths.patch;
      inherit coreutils plymouth xwayland;
    })

    # The following patches implement certain environment variables in GDM which are set by
    # the gdm configuration module (nixos/modules/services/x11/display-managers/gdm.nix).

    ./gdm-x-session_extra_args.patch

    # Allow specifying a wrapper for running the session command.
    ./gdm-x-session_session-wrapper.patch

    # Forwards certain environment variables to the gdm-x-session child process
    # to ensure that the above two patches actually work.
    ./gdm-session-worker_forward-vars.patch

    # Set up the environment properly when launching sessions
    # https://github.com/NixOS/nixpkgs/issues/48255
    ./reset-environment.patch
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
