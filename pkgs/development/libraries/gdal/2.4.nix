{ lib, stdenv, fetchurl, fetchpatch, libjpeg, libtiff, zlib
, postgresql, libmysqlclient, libgeotiff, python3Packages, proj, geos, openssl
, libpng, sqlite, libspatialite, poppler, hdf4, qhull, giflib, expat
, libiconv, libxml2
, netcdfSupport ? true, netcdf, hdf5, curl
}:

with lib;

stdenv.mkDerivation rec {
  pname = "gdal";
  version = "2.4.4";

  src = fetchurl {
    url = "https://download.osgeo.org/gdal/${version}/${pname}-${version}.tar.xz";
    sha256 = "1n6w0m2603q9cldlz0wyscp75ci561dipc36jqbf3mjmylybv0x3";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/OSGeo/gdal/commit/7a18e2669a733ebe3544e4f5c735fd4d2ded5fa3.patch";
      sha256 = "sha256-rBgIxJcgRzZR1gyzDWK/Sh7MdPWeczxEYVELbYEV8JY=";
      relative = "gdal";
      # this doesn't apply correctly because of line endings
      excludes = [ "third_party/LercLib/Lerc2.h" ];
    })
  ];

  buildInputs = [ libjpeg libtiff libgeotiff libpng proj openssl sqlite
    libspatialite poppler hdf4 qhull giflib expat libxml2 proj ]
  ++ (with python3Packages; [ python numpy wrapPython ])
  ++ lib.optional stdenv.isDarwin libiconv
  ++ lib.optionals netcdfSupport [ netcdf hdf5 curl ];

  configureFlags = [
    "--with-expat=${expat.dev}"
    "--with-jpeg=${libjpeg.dev}"
    "--with-libtiff=${libtiff.dev}" # optional (without largetiff support)
    "--with-png=${libpng.dev}"      # optional
    "--with-poppler=${poppler.dev}" # optional
    "--with-libz=${zlib.dev}"       # optional
    "--with-pg=${postgresql}/bin/pg_config"
    "--with-mysql=${getDev libmysqlclient}/bin/mysql_config"
    "--with-geotiff=${libgeotiff.dev}"
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
    homepage = "https://www.gdal.org/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.marcweber ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
