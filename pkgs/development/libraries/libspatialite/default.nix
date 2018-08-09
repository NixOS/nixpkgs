{ stdenv, lib, fetchurl, pkgconfig, libxml2, sqlite, zlib, proj, geos, libiconv }:

with lib;

stdenv.mkDerivation rec {
  name = "libspatialite-4.3.0a";

  src = fetchurl {
    url = "https://www.gaia-gis.it/gaia-sins/libspatialite-sources/${name}.tar.gz";
    sha256 = "16d4lpl7xrm9zy4gphy6nwanpjp8wn9g4wq2i2kh8abnlhq01448";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libxml2 sqlite zlib proj geos libiconv ];

  configureFlags = [ "--disable-freexl" ];

  enableParallelBuilding = true;

  postInstall = "" + optionalString stdenv.isDarwin ''
    ln -s $out/lib/mod_spatialite.{so,dylib}
  '';

  meta = {
    description = "Extensible spatial index library in C++";
    homepage = https://www.gaia-gis.it/fossil/libspatialite;
    # They allow any of these
    license = with licenses; [ gpl2Plus lgpl21Plus mpl11 ];
    platforms = platforms.unix;
  };
}
