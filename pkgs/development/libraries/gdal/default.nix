{ stdenv, fetchurl, composableDerivation, unzip, libjpeg, libtiff, zlib
, postgresql, mysql, libgeotiff }:

composableDerivation.composableDerivation {} (fixed: {
  name = "gdal-1.7.1";

  src = fetchurl {
    url = ftp://ftp.remotesensing.org/gdal/gdal171.zip;
    md5 = "f5592cff69b239166c9b64ff81943b1a";
  };

  buildInputs = [ unzip libjpeg ];

  # don't use optimization for gcc >= 4.3. That's said to be causeing segfaults
  preConfigure = "export CFLAGS=-O0; export CXXFLAGS=-O0";

  configureFlags = [
    "--with-jpeg=${libjpeg}"
    "--with-libtiff=${libtiff}"  # optional (without largetiff support
    "--with-libz=${zlib}"        # optional

    "--with-pg=${postgresql}/bin/pg_config"
    "--with-mysql=${mysql}/bin/mysql_config"
    "--with-geotiff=${libgeotiff}"
  ];

  meta = {
    description = "Translator library for raster geospatial data formats";
    homepage = http://www.gdal.org/;
    license = "X/MIT";
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
})
