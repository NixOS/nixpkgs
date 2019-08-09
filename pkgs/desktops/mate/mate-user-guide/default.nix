{ stdenv, fetchurl, intltool, itstool, libxml2, yelp }:

stdenv.mkDerivation rec {
  name = "mate-user-guide-${version}";
  version = "1.22.2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "01kcszsjiriqp4hf1k4fhazi2yfqlkn415sfgx0jw0p821bzqf2h";
  };

  nativeBuildInputs = [ itstool intltool libxml2 ];

  buildInputs = [ yelp ];

  meta = with stdenv.lib; {
    description = "MATE User Guide";
    homepage = https://mate-desktop.org;
    license = with licenses; [ gpl2Plus fdl12 ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
