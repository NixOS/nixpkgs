{ stdenv, fetchurl, intltool, itstool, libxml2, yelp, mate }:

stdenv.mkDerivation rec {
  name = "mate-user-guide-${version}";
  version = "1.20.2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "0cbi625xd7nsifvxbixsb29kj2zj14sn0sl61wkcvasz7whg7w6r";
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
