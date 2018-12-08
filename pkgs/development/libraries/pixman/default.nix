{ stdenv, fetchurl, fetchpatch, pkgconfig, libpng, glib /*just passthru*/ }:

stdenv.mkDerivation rec {
  name = "pixman-${version}";
  version = "0.36.0";

  src = fetchurl {
    url = "mirror://xorg/individual/lib/${name}.tar.bz2";
    sha256 = "1p40fygy9lcn6ypkzh14azksi570brcpr3979bjpff8qk76c14px";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libpng ];

  configureFlags = stdenv.lib.optional stdenv.isAarch32 "--disable-arm-iwmmxt";

  doCheck = true;

  postInstall = glib.flattenInclude;

  meta = with stdenv.lib; {
    homepage = http://pixman.org;
    description = "A low-level library for pixel manipulation";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
