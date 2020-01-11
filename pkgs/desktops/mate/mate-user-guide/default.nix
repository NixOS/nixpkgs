{ stdenv, fetchurl, intltool, itstool, libxml2, yelp }:

stdenv.mkDerivation rec {
  pname = "mate-user-guide";
  version = "1.22.3";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0zv8arsxnbab0qk3ck9i1wp3d4gfclcv6vq6nh5i8zjz6rpp9cjs";
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
