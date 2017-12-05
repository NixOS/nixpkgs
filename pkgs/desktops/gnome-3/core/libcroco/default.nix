{ stdenv, fetchurl, pkgconfig, libxml2, glib }:

stdenv.mkDerivation rec {
  name = "libcroco-0.6.12";

  src = fetchurl {
    url = "mirror://gnome/sources/libcroco/0.6/${name}.tar.xz";
    sha256 = "0q7qhi7z64i26zabg9dbs5706fa8pmzp1qhpa052id4zdiabbi6x";
  };

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  configureFlags = stdenv.lib.optional stdenv.isDarwin "--disable-Bsymbolic";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libxml2 glib ];

  meta = with stdenv.lib; {
    description = "GNOME CSS2 parsing and manipulation toolkit";
    homepage = https://git.gnome.org/browse/libcroco;
    license = licenses.lgpl2;
    platforms = platforms.unix;
  };
}
