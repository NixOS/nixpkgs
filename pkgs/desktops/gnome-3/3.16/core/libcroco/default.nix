{ stdenv, fetchurl, pkgconfig, libxml2, glib }:

stdenv.mkDerivation rec {
  name = "libcroco-0.6.8";

  src = fetchurl {
    url = "mirror://gnome/sources/libcroco/0.6/${name}.tar.xz";
    sha256 = "0w453f3nnkbkrly7spx5lx5pf6mwynzmd5qhszprq8amij2invpa";
  };

  outputs = [ "dev" "out" ];
  outputBin = "dev";

  configureFlags = stdenv.lib.optional stdenv.isDarwin "--disable-Bsymbolic";

  buildInputs = [ pkgconfig libxml2 glib ];

  meta = with stdenv.lib; {
    platforms = platforms.unix;
  };
}
