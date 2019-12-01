{ stdenv, fetchurl, substituteAll, pkgconfig, glib, itstool, libxml2, xorg
, accountsservice, libX11, gnome3, systemd, autoreconfHook, dconf
, gtk3, libcanberra-gtk3, pam, libtool, gobject-introspection, plymouth
, librsvg, coreutils, xwayland, nixos-icons, fetchpatch }:

let

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/4f041870efa1a6f0799ef4b32bb7be2cafee7a74/logo/nixos.svg";
    sha256 = "0b0dj408c1wxmzy6k0pjwc4bzwq286f1334s3cqqwdwjshxskshk";
  };

  override = substituteAll {
    src = ./org.gnome.login-screen.gschema.override;
    inherit icon;
  };

in

stdenv.mkDerivation rec {
  pname = "gdm";
  version = "3.34.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gdm/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1lyqvcwxhwxklbxn4xjswjzr6fhjix6h28mi9ypn34wdm9bzcpg8";
  };

  # Only needed to make it build
  preConfigure = ''
    substituteInPlace ./configure --replace "/usr/bin/X" "${xorg.xorgserver.out}/bin/X"
  '';

  initialVT = "7";

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-plymouth=yes"
    "--enable-gdm-xsession"
    "--with-initial-vt=${initialVT}"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    "--with-udevdir=$(out)/lib/udev"
  ];

  nativeBuildInputs = [ pkgconfig libxml2 itstool autoreconfHook libtool dconf ];
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

  preInstall = ''
    schema_dir=${glib.makeSchemaPath "$out" "${pname}-${version}"}
    install -D ${override} $schema_dir/org.gnome.login-screen.gschema.override
  '';

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
