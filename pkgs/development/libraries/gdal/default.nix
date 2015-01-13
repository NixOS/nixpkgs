{ stdenv, fetchurl, composableDerivation, unzip, libjpeg, libtiff, zlib
, postgresql, mysql, libgeotiff, python, pythonPackages, proj}:

composableDerivation.composableDerivation {} (fixed: rec {
  version = "1.11.1";
  name = "gdal-${version}";

  src = fetchurl {
    url = "http://download.osgeo.org/gdal/${version}/${name}.tar.gz";
    sha256 = "0h1kib2pzv4nbppdnxv6vhngvk9ic531y8rzcwb8bg6am125jszl";
  };

  buildInputs = [ unzip libjpeg libtiff python pythonPackages.numpy proj];

  # don't use optimization for gcc >= 4.3. That's said to be causeing segfaults
  preConfigure = "export CFLAGS=-O0; export CXXFLAGS=-O0";

  configureFlags = [
    "--with-jpeg=${libjpeg}"
    "--with-libtiff=${libtiff}" # optional (without largetiff support
    "--with-libz=${zlib}"       # optional

    "--with-pg=${postgresql}/bin/pg_config"
    "--with-mysql=${mysql}/bin/mysql_config"
    "--with-geotiff=${libgeotiff}"
    "--with-python"               # optional
    "--with-static-proj4=${proj}" # optional
  ];

  meta = {
    description = "Translator library for raster geospatial data formats";
    homepage = http://www.gdal.org/;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
    broken = true;
  };
})
