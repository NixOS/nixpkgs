{ lib, stdenv, fetchFromGitHub, fetchpatch, unzip, libjpeg, libtiff, zlib, postgresql
, libmysqlclient, libgeotiff, pythonPackages, proj, geos, openssl, libpng
, sqlite, libspatialite, poppler, hdf4, qhull, giflib, expat, libiconv, libxml2
, autoreconfHook, netcdfSupport ? true, netcdf, hdf5, curl, pkg-config }:

with lib;

stdenv.mkDerivation rec {
  pname = "gdal";
  version = "3.4.2";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "gdal";
    rev = "v${version}";
    sha256 = "sha256-bE55VV0SrG8nxCLdpODRalnuAkn+olRdMLUjduavj6M=";
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

  doInstallCheck = true;
  # preCheck rather than preInstallCheck because this is what pytestCheckHook
  # calls (coming from the python world)
  preCheck = ''
    pushd ../autotest
    # something has made files here read-only by this point
    chmod -R u+w .

    export HOME=$(mktemp -d)
    export PYTHONPATH="$out/${pythonPackages.python.sitePackages}:$PYTHONPATH"
  '';
  installCheckInputs = with pythonPackages; [
    pytestCheckHook
    pytest-env
    lxml
  ];
  disabledTestPaths = [
    # tests that attempt to make network requests
    "gcore/vsis3.py"
    "gdrivers/gdalhttp.py"
    "gdrivers/wms.py"
  ];
  disabledTests = [
    # tests that attempt to make network requests
    "test_jp2openjpeg_45"
    # tests that require the full proj dataset which we don't package yet
    # https://github.com/OSGeo/gdal/issues/5523
    "test_transformer_dem_overrride_srs"
    "test_osr_ct_options_area_of_interest"
  ] ++ lib.optionals (!stdenv.isx86_64) [
    # likely precision-related expecting x87 behaviour
    "test_jp2openjpeg_22"
  ] ++ lib.optionals stdenv.isDarwin [
    # flaky on macos
    "test_rda_download_queue"
  ];
  postCheck = ''
    popd # ../autotest
  '';

  meta = {
    description = "Translator library for raster geospatial data formats";
    homepage = "https://www.gdal.org/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.marcweber ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
