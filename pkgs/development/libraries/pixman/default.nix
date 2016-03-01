{ fetchurl, stdenv, pkgconfig, libpng, glib /*just passthru*/ }:

stdenv.mkDerivation rec {
  name = "pixman-0.34.0";

  src = fetchurl {
    url = "mirror://xorg/individual/lib/${name}.tar.bz2";
    sha256 = "184lazwdpv67zrlxxswpxrdap85wminh1gmq1i5lcz6iycw39fir";
  };

  patches = [];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = stdenv.lib.optional doCheck libpng;

  configureFlags = stdenv.lib.optional stdenv.isArm "--disable-arm-iwmmxt";

  doCheck = true;

  postInstall = glib.flattenInclude;

  meta = with stdenv.lib; {
    homepage = http://pixman.org;
    description = "A low-level library for pixel manipulation";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
