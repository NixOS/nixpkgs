{ stdenv, fetchFromGitLab, autoconf, automake, glib
, gtk_doc, libtool, libxml2, libxslt, pkgconfig, sqlite }:

let version = "1.18"; in
stdenv.mkDerivation rec {
  name = "libaccounts-glib-${version}";

  src = fetchFromGitLab {
    sha256 = "02p23vrqhw2l2w6nrwlk4bqxf7z9kplkc2d43716x9xakxr291km";
    rev = version;
    repo = "libaccounts-glib";
    owner = "accounts-sso";
  };

  buildInputs = [ glib libxml2 libxslt sqlite ];
  nativeBuildInputs = [ autoconf automake gtk_doc libtool pkgconfig ];

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
