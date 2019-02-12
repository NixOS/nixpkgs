{ stdenv, fetchurl, fetchpatch, unzip, libjpeg, libtiff, zlib
, postgresql, mysql, libgeotiff, pythonPackages, proj, geos, openssl
, libpng, sqlite, libspatialite, poppler, hdf4, qhull, giflib, expat
, libiconv, libxml2
, netcdfSupport ? true, netcdf, hdf5, curl
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "gdal-${version}";
  version = "2.4.0";

  src = fetchurl {
    url = "https://download.osgeo.org/gdal/${version}/${name}.tar.xz";
    sha256 = "09qgy36z0jc9w05373m4n0vm4j54almdzql6z9p9zr9pdp61syf3";
  };

  buildInputs = [ unzip libjpeg libtiff libpng proj openssl sqlite
    libspatialite poppler hdf4 qhull giflib expat libxml2 ]
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
    "--with-proj=${proj}" # optional
    "--with-geos=${geos}/bin/geos-config"# optional
    "--with-hdf4=${hdf4.dev}" # optional
    "--with-xml2=${libxml2.dev}/bin/xml2-config" # optional
    (if netcdfSupport then "--with-netcdf=${netcdf}" else "")
  ];

  hardeningDisable = [ "format" ];

  CXXFLAGS = "-fpermissive";

  postPatch = ''
    sed -i '/ifdef bool/i\
      #ifdef swap\
      #undef swap\
      #endif' ogr/ogrsf_frmts/mysql/ogr_mysql.h

    # poppler 0.73.0 support
    patch -lp2 <${
      fetchpatch {
        url = "https://github.com/OSGeo/gdal/commit/29f4dfbcac2de718043f862166cd639ab578b552.diff";
        sha256 = "1h2rsjjrgwqfgqzppmzv5jgjs1dbbg8pvfmay0j9y0618qp3r734";
      }
    } || true
    patch -p2 <${
      fetchpatch {
        url = "https://github.com/OSGeo/gdal/commit/19967e682738977e11e1d0336e0178882c39cad2.diff";
        sha256 = "12yqd77226i6xvzgqmxiac5ghdinixh8k2crg1r2gnhc0xlc3arj";
      }
    }
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
