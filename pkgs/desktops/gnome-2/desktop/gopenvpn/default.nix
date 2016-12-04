{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, automake111x, glib, gtk2, gnome2, dbus_glib, gmime,
  libnotify, libgnome_keyring, libglade, polkit, openvpn, pkexecPath ? "/var/setuid-wrappers/pkexec" }:

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

  buildInputs = [ glib gtk2 dbus_glib gmime libnotify libgnome_keyring pkgconfig automake111x autoreconfHook
                  libglade polkit openvpn ];

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
  configureFlags = ["--with-pkexec=${pkexecPath}"];

  meta = with stdenv.lib; {
    description = "Graphical front-end for OpenVPN";
    homepage = "http://gopenvpn.sourceforge.net/";
    license = "GPL";
    platforms = platforms.unix;
    maintainers = [ maintainers.eleanor ];
  };
}
