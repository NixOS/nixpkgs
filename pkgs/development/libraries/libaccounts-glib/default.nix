{ stdenv, fetchurl, glib, libxml2, libxslt, pkgconfig, sqlite }:

stdenv.mkDerivation rec {
  name = "libaccounts-glib-1.16";
  src = fetchurl {
    url = "https://accounts-sso.googlecode.com/files/${name}.tar.gz";
    sha256 = "0hgvk9rdfvk47c54rvcp3hq74yy7v6w1ql71q2mik8lmsx22354a";
  };

  buildInputs = [ glib libxml2 libxslt sqlite ];
  nativeBuildInputs = [ pkgconfig ];

  configurePhase = ''HAVE_GCOV_FALSE='#' ./configure $configureFlags --prefix=$out'';

}
