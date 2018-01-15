{ stdenv, fetchurl, intltool, itstool, libxml2, yelp }:

stdenv.mkDerivation rec {
  name = "mate-user-guide-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
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
