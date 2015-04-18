{ stdenv, fetchurl, intltool, gobjectIntrospection, pkgconfig }:

stdenv.mkDerivation rec {
  name = "gcab-0.6";

  src = fetchurl {
    url = "mirror://gnome/sources/gcab/0.6/${name}.tar.xz";
    sha256 = "a0443b904bfa7227b5155bfcdf9ea9256b6e26930b8febe1c41f972f6f1334bb";
  };

  buildInputs = [ intltool gobjectIntrospection pkgconfig ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };

}
