{ stdenv, fetchurl, composableDerivation, unzip, libjpeg, libtiff, zlib
, postgresql, mysql, libgeotiff, python, pythonPackages}:

composableDerivation.composableDerivation {} (fixed: rec {
  name = "gdal-1.11.0";

  src = fetchurl {
    url = "http://download.osgeo.org/gdal/1.11.0/${name}.tar.gz";
    md5 = "9fdf0f2371a3e9863d83e69951c71ec4";
  };

  buildInputs = [ unzip libjpeg libtiff python pythonPackages.numpy];

  # don't use optimization for gcc >= 4.3. That's said to be causeing segfaults
  preConfigure = "export CFLAGS=-O0; export CXXFLAGS=-O0";

  configureFlags = [
    "--with-jpeg=${libjpeg}"
    "--with-libtiff=${libtiff}"  # optional (without largetiff support
    "--with-libz=${zlib}"        # optional

    "--with-pg=${postgresql}/bin/pg_config"
    "--with-mysql=${mysql}/bin/mysql_config"
    "--with-geotiff=${libgeotiff}"
    "--with-python"    # optional
  ];

  meta = {
    description = "Translator library for raster geospatial data formats";
    homepage = http://www.gdal.org/;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
})
