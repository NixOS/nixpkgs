{ stdenv, fetchurl, pkgconfig, libxml2, glib }:

stdenv.mkDerivation rec {
  name = "libcroco-0.6.11";

  src = fetchurl {
    url = "mirror://gnome/sources/libcroco/0.6/${name}.tar.xz";
    sha256 = "0mm0wldbi40am5qn0nv7psisbg01k42rwzjxl3gv11l5jj554aqk";
  };

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  configureFlags = stdenv.lib.optional stdenv.isDarwin "--disable-Bsymbolic";

  buildInputs = [ pkgconfig libxml2 glib ];

  meta = with stdenv.lib; {
    platforms = platforms.unix;
  };
}
