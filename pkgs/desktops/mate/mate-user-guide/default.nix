{ stdenv, fetchurl, intltool, itstool, libxml2, yelp, mate }:

stdenv.mkDerivation rec {
  name = "mate-user-guide-${version}";
  version = "1.20.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "1n1rlvymz8k7vvjmd9qkv26wz3770w1ywsa41kbisbfp9x7mr0w2";
  };

  nativeBuildInputs = [ itstool intltool libxml2 ];

  buildInputs = [ yelp ];

  meta = with stdenv.lib; {
    description = "MATE User Guide";
    homepage = http://mate-desktop.org;
    license = with licenses; [ gpl2Plus fdl12 ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
