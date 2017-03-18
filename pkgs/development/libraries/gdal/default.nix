{ stdenv, fetchurl, composableDerivation, unzip, libjpeg, libtiff, zlib
, postgresql, mysql, libgeotiff, pythonPackages, proj, geos, openssl
, libpng
, netcdf, hdf5 , curl
, netcdfSupport ? true
 }:

composableDerivation.composableDerivation {} (fixed: rec {
  version = "2.1.3";
  name = "gdal-${version}";

  src = fetchurl {
    url = "http://download.osgeo.org/gdal/${version}/${name}.tar.gz";
    sha256 = "0jh7filpf5dk5iz5acj7y3y49ihnzqypxckdlj0sjigbqq6hlsmf";
  };

  buildInputs = [ unzip libjpeg libtiff libpng proj openssl ]
  ++ (with pythonPackages; [ python numpy wrapPython ])
  ++ (stdenv.lib.optionals netcdfSupport [ netcdf hdf5 curl ]);

  hardeningDisable = [ "format" ];

  # Unset CC and CXX as they confuse libtool.
  preConfigure = "unset CC CXX";

  configureFlags = [
    "--with-jpeg=${libjpeg.dev}"
    "--with-libtiff=${libtiff.dev}" # optional (without largetiff support)
    "--with-png=${libpng.dev}"      # optional
    "--with-libz=${zlib.dev}"       # optional

    "--with-pg=${postgresql}/bin/pg_config"
    "--with-mysql=${mysql.lib.dev}/bin/mysql_config"
    "--with-geotiff=${libgeotiff}"
    "--with-python"               # optional
    "--with-static-proj4=${proj}" # optional
    "--with-geos=${geos}/bin/geos-config"# optional
    (if netcdfSupport then "--with-netcdf=${netcdf}" else "")
  ];

  preBuild = ''
    substituteInPlace swig/python/GNUmakefile \
      --replace "ifeq (\$(STD_UNIX_LAYOUT),\"TRUE\")" "ifeq (1,1)"
  '';

  postInstall = ''
    wrapPythonPrograms
  '';

  meta = {
    description = "Translator library for raster geospatial data formats";
    homepage = http://www.gdal.org/;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
})
