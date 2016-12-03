{ stdenv, fetchurl, fetchFromGitHub, pkgconfig, glib, gtk2, gnome2, dbus_glib, gmime, libnotify, libgnome_keyring,
  openssl, cyrus_sasl, gnonlin, sylpheed, gob2, gettext, intltool, libglade, polkit, autoconf, automake, expect,
  openvpn, makeWrapper, pkexecPath ? "/var/setuid-wrappers/pkexec" }:

stdenv.mkDerivation rec {
  rev = "2b9285f1ea2d11434b8ee8e10d937b2ea5285b63";
  version = "0.8";
  name = "gopenvpn-${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "proteansec";
    repo = "gopenvpn";
    sha256 = "0pkdravr5wm7phdr2rd1rx1ry4dpwkrf0hv7wi99n4ywsl5jqwq8";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib gtk2 dbus_glib gmime libnotify libgnome_keyring openssl cyrus_sasl gnonlin sylpheed gob2
                  gettext intltool libglade polkit pkgconfig autoconf automake expect openvpn makeWrapper ];

  # disable the format hardening flags in order for the program to compile even though a potential vulnerability
  # might be present in the form of a format string vulnerability. By failing to add this the program compilation
  # will end with the following line:
  #
  #  > gopenvpn.c:978:10: error: format not a string literal and no format arguments [-Werror=format-security]
  #
  hardeningDisable = [ "format" ];

  patchPhase = ''
    # configure and remote extra "po/Makefile.in" in AC_CONFIG_FILES
    sed -i -e 's:AC_CONFIG_FILES(\[pixmaps/Makefile po/Makefile.in:AC_CONFIG_FILES(\[pixmaps/Makefile:g' configure.ac
    cat configure.ac | grep CONFIG_FILES
  '';

  # configure with pkexec to be able to run openvpn as privileged user
  configureFlags = ["--with-pkexec=${pkexecPath}/bin/pkexec"];

  preConfigure = ''
    # copy standard gettext infrastructure files into a source package
    autopoint -f
    expect -c "spawn gettextize -f; expect -re \"Press Return to acknowledge the previous\""

    # updating configuration files not required anymore due to autoreconfHook
    autoreconf -vif
  '';

  meta = with stdenv.lib; {
    description = "Graphical front-end for OpenVPN";
    homepage = "http://gopenvpn.sourceforge.net/";
    license = "GPL";
    platforms = platforms.unix;
    maintainers = [ maintainers.eleanor ];
  };
}
