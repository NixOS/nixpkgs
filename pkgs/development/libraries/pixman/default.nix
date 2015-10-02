{ fetchurl, stdenv, pkgconfig, libpng, glib /*just passthru*/ }:

stdenv.mkDerivation rec {
  name = "pixman-0.32.8";

  src = fetchurl {
    url = "mirror://xorg/individual/lib/${name}.tar.bz2";
    sha1 = "5c57045622265b877c9bf02d531973eadf942140";
  };

  patches = stdenv.lib.optional stdenv.isDarwin ./fix-clang36.patch;

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
