{ lib
, stdenv
, fetchFromGitHub
, bison
, cmake
, doxygen
, graphviz
, pkg-config
, python3
, swig
, armadillo
, arrow-cpp
, c-blosc
, brunsli
, cfitsio
, crunch
, curl
, cryptopp
, libdeflate
, expat
, libgeotiff
, geos
, giflib
, libheif
, dav1d
, libaom
, libde265
, rav1e
, x265
, hdf4
, hdf5-cpp
, libiconv
, libjpeg
, json_c
, libjxl
, libhwy
, lerc
, xz
, libxml2
, lz4
, libmysqlclient
, netcdf
, openexr
, openjpeg
, openssl
, pcre2
, libpng
, poppler
, postgresql
, proj
, qhull
, libspatialite
, sqlite
, libtiff
, tiledb
, libwebp
, xercesc
, zlib
, zstd
}:

stdenv.mkDerivation rec {
  pname = "gdal";
  version = "3.6.3";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "gdal";
    rev = "v${version}";
    hash = "sha256-Rg/dvSkq1Hn8NgZEE0ID92Vihyw7MA78OBnON8Riy38=";
  };

  nativeBuildInputs = [
    bison
    cmake
    doxygen
    graphviz
    pkg-config
    python3.pkgs.setuptools
    python3.pkgs.wrapPython
    swig
  ];

  cmakeFlags = [
    "-DGDAL_USE_INTERNAL_LIBS=OFF"
    "-DGEOTIFF_INCLUDE_DIR=${lib.getDev libgeotiff}/include"
    "-DGEOTIFF_LIBRARY_RELEASE=${lib.getLib libgeotiff}/lib/libgeotiff${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DMYSQL_INCLUDE_DIR=${lib.getDev libmysqlclient}/include/mysql"
    "-DMYSQL_LIBRARY=${lib.getLib libmysqlclient}/lib/${lib.optionalString (libmysqlclient.pname != "mysql") "mysql/"}libmysqlclient${stdenv.hostPlatform.extensions.sharedLibrary}"
  ] ++ lib.optionals (!stdenv.isDarwin) [
    "-DCMAKE_SKIP_BUILD_RPATH=ON" # without, libgdal.so can't find libmariadb.so
  ] ++ lib.optionals stdenv.isDarwin [
    "-DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON"
  ];

  buildInputs = [
    armadillo
    c-blosc
    brunsli
    cfitsio
    crunch
    curl
    cryptopp
    libdeflate
    expat
    libgeotiff
    geos
    giflib
    libheif
    dav1d  # required by libheif
    libaom  # required by libheif
    libde265  # required by libheif
    rav1e  # required by libheif
    x265  # required by libheif
    hdf4
    hdf5-cpp
    libjpeg
    json_c
    libjxl
    libhwy  # required by libjxl
    lerc
    xz
    libxml2
    lz4
    libmysqlclient
    netcdf
    openjpeg
    openssl
    pcre2
    libpng
    poppler
    postgresql
    proj
    qhull
    libspatialite
    sqlite
    libtiff
    tiledb
    libwebp
    zlib
    zstd
    python3
    python3.pkgs.numpy
  ] ++ lib.optionals (!stdenv.isDarwin) [
    # tests for formats enabled by these packages fail on macos
    arrow-cpp
    openexr
    xercesc
  ] ++ lib.optional stdenv.isDarwin libiconv;

  postInstall = ''
    wrapPythonPrograms
  '';

  enableParallelBuilding = true;

  doInstallCheck = true;
  # preCheck rather than preInstallCheck because this is what pytestCheckHook
  # calls (coming from the python world)
  preCheck = ''
    pushd ../autotest

    export HOME=$(mktemp -d)
    export PYTHONPATH="$out/${python3.sitePackages}:$PYTHONPATH"
  '';
  nativeInstallCheckInputs = with python3.pkgs; [
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
    # ZIP does not support timestamps before 1980
    " test_sentinel2_zipped"
    # tries to call unwrapped executable
    "test_SetPROJAuxDbPaths"
  ] ++ lib.optionals (!stdenv.isx86_64) [
    # likely precision-related expecting x87 behaviour
    "test_jp2openjpeg_22"
  ] ++ lib.optionals stdenv.isDarwin [
    # flaky on macos
    "test_rda_download_queue"
  ] ++ lib.optionals (lib.versionOlder proj.version "8") [
    "test_ogr_parquet_write_crs_without_id_in_datum_ensemble_members"
  ];
  postCheck = ''
    popd # ../autotest
  '';

  meta = {
    description = "Translator library for raster geospatial data formats";
    homepage = "https://www.gdal.org/";
    changelog = "https://github.com/OSGeo/gdal/blob/${src.rev}/NEWS.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marcweber dotlambda ];
    platforms = lib.platforms.unix;
  };
}
