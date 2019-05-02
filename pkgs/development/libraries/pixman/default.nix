{ stdenv, fetchurl, fetchpatch, pkgconfig, libpng, glib /*just passthru*/ }:

stdenv.mkDerivation rec {
  name = "pixman-${version}";
  version = "0.38.4";

  src = fetchurl {
    url = "mirror://xorg/individual/lib/${name}.tar.bz2";
    sha256 = "0l0m48lnmdlmnaxn2021qi5cj366d9fzfjxkqgcj9bs14pxbgaw4";
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
