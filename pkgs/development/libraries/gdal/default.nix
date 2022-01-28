{ lib, stdenv, fetchFromGitHub, fetchpatch, unzip, libjpeg, libtiff, zlib, postgresql
, libmysqlclient, libgeotiff, pythonPackages, proj, geos, openssl, libpng
, sqlite, libspatialite, poppler, hdf4, qhull, giflib, expat, libiconv, libxml2
, autoreconfHook, netcdfSupport ? true, netcdf, hdf5, curl, pkg-config }:

with lib;

stdenv.mkDerivation rec {
  pname = "gdal";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "gdal";
    rev = "v${version}";
    sha256 = "11rjdaxmsp9n3r9xhmgd7ksy8bh5fazwsxdj0xvl4hsy6bcn4n97";
  };

  sourceRoot = "source/gdal";

  nativeBuildInputs = [ autoreconfHook pkg-config unzip ];

  buildInputs = [
    libjpeg
    libtiff
    libpng
    proj
    openssl
    sqlite
    libspatialite
    libgeotiff
    poppler
    hdf4
    qhull
    giflib
    expat
    libxml2
    postgresql
  ] ++ (with pythonPackages; [ python setuptools numpy wrapPython ])
    ++ lib.optional stdenv.isDarwin libiconv
    ++ lib.optionals netcdfSupport [ netcdf hdf5 curl ];

  configureFlags = [
    "--with-expat=${expat.dev}"
    "--with-jpeg=${libjpeg.dev}"
    "--with-libtiff=${libtiff.dev}" # optional (without largetiff support)
    "--with-png=${libpng.dev}" # optional
    "--with-poppler=${poppler.dev}" # optional
    "--with-libz=${zlib.dev}" # optional
    "--with-pg=yes" # since gdal 3.0 doesn't use ${postgresql}/bin/pg_config
    "--with-mysql=${getDev libmysqlclient}/bin/mysql_config"
    "--with-geotiff=${libgeotiff}"
    "--with-sqlite3=${sqlite.dev}"
    "--with-spatialite=${libspatialite.dev}"
    "--with-python" # optional
    "--with-proj=${proj.dev}" # optional
    "--with-geos=${geos}/bin/geos-config" # optional
    "--with-hdf4=${hdf4.dev}" # optional
    "--with-xml2=yes" # optional
    (if netcdfSupport then "--with-netcdf=${netcdf}" else "")
  ];

  hardeningDisable = [ "format" ];

  CXXFLAGS = lib.concatStringsSep " " [
    "-fpermissive"
    # poppler uses std::optional
    "-std=c++17"
  ];

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
    homepage = "https://www.gdal.org/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.marcweber ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
