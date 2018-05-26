{ stdenv, fetchFromGitLab, autoconf, automake, glib
, gtk-doc, libtool, libxml2, libxslt, pkgconfig, sqlite }:

let version = "1.23"; in
stdenv.mkDerivation rec {
  name = "libaccounts-glib-${version}";

  src = fetchFromGitLab {
    sha256 = "11cvl3ch0y93756k90mw1swqv0ylr8qgalmvcn5yari8z4sg6cgg";
    rev = "VERSION_${version}";
    repo = "libaccounts-glib";
    owner = "accounts-sso";
  };

  buildInputs = [ glib libxml2 libxslt sqlite ];
  nativeBuildInputs = [ autoconf automake gtk-doc libtool pkgconfig ];

  postPatch = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  configurePhase = ''
    HAVE_GCOV_FALSE="#" ./configure $configureFlags --prefix=$out
  '';

  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations"; # since glib-2.46

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
