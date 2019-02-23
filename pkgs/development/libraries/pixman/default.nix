{ stdenv, fetchurl, fetchpatch, pkgconfig, libpng, glib /*just passthru*/ }:

stdenv.mkDerivation rec {
  name = "pixman-${version}";
  version = "0.38.0";

  src = fetchurl {
    url = "mirror://xorg/individual/lib/${name}.tar.bz2";
    sha256 = "1a1nnkjv0rqdj26847r0saly0kzckjfp4y3ly30bvpjxi7vy6s5p";
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
