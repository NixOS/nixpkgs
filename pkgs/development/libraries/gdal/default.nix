{ stdenv, fetchurl, fetchpatch, unzip, libjpeg, libtiff, zlib
, postgresql, mysql, libgeotiff, pythonPackages, proj, geos, openssl
, libpng, sqlite, libspatialite, poppler, hdf4
, libiconv
, netcdfSupport ? true, netcdf, hdf5 , curl
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "2.3.0";
  name = "gdal-${version}";

  src = fetchurl {
    url = "http://download.osgeo.org/gdal/${version}/${name}.tar.xz";
    sha256 = "18iaamzkn0lipizynvspf3bs5qzgcy36hn6bbi941q8dlfdf8xbg";
  };

  patches = [
    # fix build with recent Poppler
    (fetchpatch {
      url    = "https://github.com/OSGeo/gdal/commit/124f0343436d1267319ac627fc220530091b41ea.diff";
      stripLen = 2;
      extraPrefix = "";
      sha256 = "1v6iiy4cgrdcfas3iva5swh9446pqfjh5p6bcab6y49hyjhpsgfy";
    })
  ];

  buildInputs = [ unzip libjpeg libtiff libpng proj openssl sqlite
    libspatialite poppler hdf4 ]
  ++ (with pythonPackages; [ python numpy wrapPython ])
  ++ stdenv.lib.optional stdenv.isDarwin libiconv
  ++ stdenv.lib.optionals netcdfSupport [ netcdf hdf5 curl ];

  configureFlags = [
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
    "--with-static-proj4=${proj}" # optional
    "--with-geos=${geos}/bin/geos-config"# optional
    "--with-hdf4=${hdf4.dev}" # optional
    (if netcdfSupport then "--with-netcdf=${netcdf}" else "")
  ];

  hardeningDisable = [ "format" ];

  CXXFLAGS = "-fpermissive";

  postPatch = ''
    sed -i '/ifdef bool/i\
      #ifdef swap\
      #undef swap\
      #endif' ogr/ogrsf_frmts/mysql/ogr_mysql.h
  '';

  # - Unset CC and CXX as they confuse libtool.
  # - teach gdal that libdf is the legacy name for libhdf
  preConfigure = ''
      unset CC CXX
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
    homepage = http://www.gdal.org/;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
