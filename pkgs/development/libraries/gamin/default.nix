{ stdenv, fetchurl, python, pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "gamin-0.1.9";

  src = fetchurl {
    url = "http://www.gnome.org/~veillard/gamin/sources/${name}.tar.gz";
    sha256 = "0fgjfyr0nlkpdxj94a4qfm82wypljdyv1b6l56v7i9jdx0hcdqhr";
  };

  buildInputs = [ python pkgconfig glib ];

  # `_GNU_SOURCE' is needed, e.g., to get `struct ucred' from
  # <sys/socket.h> with Glibc 2.9.
  configureFlags = "--disable-debug --with-python=${python} CPPFLAGS=-D_GNU_SOURCE";
}
