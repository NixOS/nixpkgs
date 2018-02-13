{ stdenv, fetchurl, intltool, itstool, libxml2, yelp, mate }:

stdenv.mkDerivation rec {
  name = "mate-user-guide-${version}";
  version = "1.18.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "0f3b46r9a3cywm7rpj08xlkfnlfr9db58xfcpix8i33qp50fxqmb";
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
