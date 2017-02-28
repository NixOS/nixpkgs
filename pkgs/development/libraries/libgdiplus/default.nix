{ stdenv, lib, fetchurl, pkgconfig, glib, cairo, Carbon, fontconfig
, libtiff, giflib, libungif, libjpeg, libpng, monoDLLFixer
, libXrender, libexif }:

stdenv.mkDerivation rec {
  name = "libgdiplus-${version}";
  version = "4.2";

  src = fetchurl {
    url = "http://download.mono-project.com/sources/libgdiplus/${name}.tar.gz";
    sha256 = "1syzpbny2gcvfca7cadqj33hdf30cclsf0cdil5wblagnjwbjcpk";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ cairo libpng libexif libtiff giflib libjpeg ]
    ++ lib.optional stdenv.isDarwin Carbon;

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    ln -s $out/lib/libgdiplus.0.dylib $out/lib/libgdiplus.so
  '';

  meta = with stdenv.lib; {
    description = "Mono library that provides a GDI+-compatible API on non-Windows operating systems";
    homepage = "http://www.mono-project.com/docs/gui/libgdiplus/";
    platforms = platforms.unix;
    license = licenses.mpl11;
  };
}
