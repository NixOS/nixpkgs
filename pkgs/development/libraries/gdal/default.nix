{ stdenv, fetchFromGitHub, fetchpatch, unzip, libjpeg, libtiff, zlib
, postgresql, mysql, libgeotiff, pythonPackages, proj, geos, openssl
, libpng, sqlite, libspatialite, poppler, hdf4, qhull, giflib, expat
, libiconv, libxml2, autoreconfHook
, netcdfSupport ? true, netcdf, hdf5, curl
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "gdal-${version}";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "gdal";
    rev = "v${version}";
    sha256 = "04rraqhygv8b8fy87qvdhkgx87whby9n98p3gxqr7kdrfymwnh8l";
  };

  sourceRoot = "source/gdal";

  patches = [ ./001.3_0_1.darwin.patch ];

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ unzip libjpeg libtiff libpng proj openssl sqlite
    libspatialite libgeotiff poppler hdf4 qhull giflib expat libxml2 ]
  ++ (with pythonPackages; [ python numpy wrapPython ])
  ++ stdenv.lib.optional stdenv.isDarwin libiconv
  ++ stdenv.lib.optionals netcdfSupport [ netcdf hdf5 curl ];

  configureFlags = [
    "--with-expat=${expat.dev}"
    "--with-jpeg=${libjpeg.dev}"
    "--with-libtiff=${libtiff.dev}" # optional (without largetiff support)
    "--with-png=${libpng.dev}"      # optional
    "--with-poppler=${poppler.dev}" # optional
    "--with-libz=${zlib.dev}"       # optional
    "--with-pg=${postgresql}/bin/pg_config"
    "--with-mysql=${mysql.connector-c or mysql}/bin/mysql_config"
    "--with-geotiff=${libgeotiff}"
    "--with-sqlite3=${sqlite.dev}"
    "--with-spatialite=${libspatialite}"
    "--with-python"               # optional
    "--with-proj=${proj.dev}" # optional
    "--with-geos=${geos}/bin/geos-config"# optional
    "--with-hdf4=${hdf4.dev}" # optional
    "--with-xml2=${libxml2.dev}/bin/xml2-config" # optional
    (if netcdfSupport then "--with-netcdf=${netcdf}" else "")
  ];

  hardeningDisable = [ "format" ];

  CXXFLAGS = "-fpermissive";

  # - Unset CC and CXX as they confuse libtool.
  # - teach gdal that libdf is the legacy name for libhdf
  preConfigure = ''
      substituteInPlace configure \
      --replace "-lmfhdf -ldf" "-lmfhdf -lhdf"
    '';

  preBuild = ''
    substituteInPlace swig/python/GNUmakefile \
      --replace "ifeq (\$(STD_UNIX_LAYOUT),\"TRUE\")" "ifeq (1,1)"
  '';

  postInstall = ''
    wrapPythonPrograms
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Translator library for raster geospatial data formats";
    homepage = https://www.gdal.org/;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
