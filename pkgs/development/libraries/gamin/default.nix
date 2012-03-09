{ stdenv, fetchurl, python, pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "gamin-0.1.10";

  src = fetchurl {
    url = "http://www.gnome.org/~veillard/gamin/sources/${name}.tar.gz";
    sha256 = "18cr51y5qacvs2fc2p1bqv32rs8bzgs6l67zhasyl45yx055y218";
  };

  buildNativeInputs = [ pkgconfig ];

  buildInputs = [ python glib ];

  # `_GNU_SOURCE' is needed, e.g., to get `struct ucred' from
  # <sys/socket.h> with Glibc 2.9.
  configureFlags = "--disable-debug --with-python=${python} CPPFLAGS=-D_GNU_SOURCE";

  patches = map fetchurl (import ./debian-patches.nix);
}
