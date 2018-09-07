{ stdenv, fetchurl, intltool, itstool, libxml2, yelp, mate }:

stdenv.mkDerivation rec {
  name = "mate-user-guide-${version}";
  version = "1.21.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "0ayg570000calzpj51dwhh5mil11s0nrhl21c0si3sxr8f5cld6q";
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
