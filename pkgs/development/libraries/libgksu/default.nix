{ stdenv, fetchurl, pkgconfig, wrapGAppsHook, gtk2, gnome2, gnome3,
  libstartup_notification, libgtop, perlPackages,
  autoreconfHook, intltool, docbook_xsl, xauth
}:

stdenv.mkDerivation rec {
  version = "2.0.12";
  pname = "libgksu";

  src = fetchurl {
    url = "http://people.debian.org/~kov/gksu/${pname}-${version}.tar.gz";
    sha256 = "1brz9j3nf7l2gd3a5grbp0s3nksmlrp6rxmgp5s6gjvxcb1wzy92";
  };

  nativeBuildInputs = [
    pkgconfig autoreconfHook intltool docbook_xsl wrapGAppsHook
  ];

  buildInputs = [
    gtk2 gnome2.GConf libstartup_notification
    gnome3.libgnome-keyring libgtop gnome2.libglade
  ] ++ (with perlPackages; [ perl XMLParser ]);

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  patches = [
        # Patches from the gentoo ebuild

        # Fix compilation on bsdc
        ./libgksu-2.0.0-fbsd.patch

        # Fix wrong usage of LDFLAGS, gentoo bug #226837
        ./libgksu-2.0.7-libs.patch

        # Use po/LINGUAS
        ./libgksu-2.0.7-polinguas.patch

        # Don't forkpty; gentoo bug #298289
        ./libgksu-2.0.12-revert-forkpty.patch

        # Make this gmake-3.82 compliant, gentoo bug #333961
        ./libgksu-2.0.12-fix-make-3.82.patch

        # Do not build test programs that are never executed; also fixes gentoo bug #367397 (underlinking issues).
        ./libgksu-2.0.12-notests.patch

        # Fix automake-1.11.2 compatibility, gentoo bug #397411
        ./libgksu-2.0.12-automake-1.11.2.patch
  ];

  postPatch = ''
    # gentoo bug #467026
    sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.ac

    # Fix some binary paths
    sed -i -e 's|/usr/bin/xauth|${xauth}/bin/xauth|g' libgksu/gksu-run-helper.c libgksu/libgksu.c
    sed -i -e 's|/usr/bin/sudo|/run/wrappers/bin/sudo|g' libgksu/libgksu.c
    sed -i -e 's|/bin/su\([^d]\)|/run/wrappers/bin/su\1|g' libgksu/libgksu.c

    touch NEWS README
  '';

  preConfigure = ''
    intltoolize --force --copy --automake
  '';

  configureFlags = [
    "--disable-gtk-doc"
  ];

  meta = {
    description = "A library for integration of su into applications";
    longDescription = ''
      This library comes from the gksu program. It provides a simple API
      to use su and sudo in programs that need to execute tasks as other
      user.  It provides X authentication facilities for running
      programs in an X session.
    '';
    homepage = "https://www.nongnu.org/gksu/";
    license = stdenv.lib.licenses.lgpl2;
    maintainers = [ stdenv.lib.maintainers.romildo ];
    platforms = stdenv.lib.platforms.linux;
  };
}
