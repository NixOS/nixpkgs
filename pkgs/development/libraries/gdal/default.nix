{ lib
, stdenv
, callPackage
, fetchFromGitHub

, useMinimalFeatures ? false
, useTiledb ? (!useMinimalFeatures) && !(stdenv.isDarwin && stdenv.isx86_64)
, useLibHEIF ? (!useMinimalFeatures)
, useLibJXL ? (!useMinimalFeatures)
, useMysql ? (!useMinimalFeatures)
, usePostgres ? (!useMinimalFeatures)
, usePoppler ? (!useMinimalFeatures)
, useArrow ? (!useMinimalFeatures)
, useHDF ? (!useMinimalFeatures)
, useNetCDF ? (!useMinimalFeatures)
, useArmadillo ? (!useMinimalFeatures)

, bison
, cmake
, gtest
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

stdenv.mkDerivation (finalAttrs: {
  pname = "gdal";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "gdal";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/7Egbg4Cg5Gqsy+CEMVbs2NCWbdJteDNWelBsrQSUj4=";
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
  ] ++ lib.optionals finalAttrs.doInstallCheck [
    "-DBUILD_TESTING=ON"
  ] ++ lib.optionals (!stdenv.isDarwin) [
    "-DCMAKE_SKIP_BUILD_RPATH=ON" # without, libgdal.so can't find libmariadb.so
  ] ++ lib.optionals stdenv.isDarwin [
    "-DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON"
  ] ++ lib.optionals (!useTiledb) [
    "-DGDAL_USE_TILEDB=OFF"
  ];

  buildInputs =
    let
      tileDbDeps = lib.optionals useTiledb [ tiledb ];
      libHeifDeps = lib.optionals useLibHEIF [
        libheif
        dav1d
        libaom
        libde265
        rav1e
        x265
      ];
      libJxlDeps = lib.optionals useLibJXL [
        libjxl
        libhwy
      ];
      mysqlDeps = lib.optionals useMysql [ libmysqlclient ];
      postgresDeps = lib.optionals usePostgres [ postgresql ];
      popplerDeps = lib.optionals usePoppler [ poppler ];
      arrowDeps = lib.optionals useArrow [ arrow-cpp ];
      hdfDeps = lib.optionals useHDF [
        hdf4
        hdf5-cpp
      ];
      netCdfDeps = lib.optionals useNetCDF [ netcdf ];
      armadilloDeps = lib.optionals useArmadillo [ armadillo ];

      darwinDeps = lib.optionals stdenv.isDarwin [ libiconv ];
      nonDarwinDeps = lib.optionals (!stdenv.isDarwin) ([
        # tests for formats enabled by these packages fail on macos
        openexr
        xercesc
      ] ++ arrowDeps);
    in [
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
      libjpeg
      json_c
      lerc
      xz
      libxml2
      lz4
      openjpeg
      openssl
      pcre2
      libpng
      proj
      qhull
      libspatialite
      sqlite
      libtiff
      gtest
      libwebp
      zlib
      zstd
      python3
      python3.pkgs.numpy
    ] ++ tileDbDeps
      ++ libHeifDeps
      ++ libJxlDeps
      ++ mysqlDeps
      ++ postgresDeps
      ++ popplerDeps
      ++ arrowDeps
      ++ hdfDeps
      ++ netCdfDeps
      ++ armadilloDeps
      ++ darwinDeps
      ++ nonDarwinDeps;

  postInstall = ''
    wrapPythonPrograms
  '';

  enableParallelBuilding = true;

  doInstallCheck = true;
  # preCheck rather than preInstallCheck because this is what pytestCheckHook
  # calls (coming from the python world)
  preCheck = ''
    pushd autotest

    export HOME=$(mktemp -d)
    export PYTHONPATH="$out/${python3.sitePackages}:$PYTHONPATH"
    export GDAL_DOWNLOAD_TEST_DATA=OFF
    # allows to skip tests that fail because of file handle leak
    # the issue was not investigated
    # https://github.com/OSGeo/gdal/blob/v3.7.0/autotest/gdrivers/bag.py#L61
    export BUILD_NAME=fedora
  '';
  nativeInstallCheckInputs = with python3.pkgs; [
    pytestCheckHook
    pytest-env
    filelock
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
    "test_sentinel2_zipped"
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
  ] ++ lib.optionals (!usePoppler) [
    "test_pdf_jpx_compression"
  ];
  postCheck = ''
    popd # autotest
  '';

  passthru.tests = {
    gdal = callPackage ./tests.nix { gdal = finalAttrs.finalPackage; };
  };

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    changelog = "https://github.com/OSGeo/gdal/blob/v${finalAttrs.version}/NEWS.md";
    description = "Translator library for raster geospatial data formats";
    homepage = "https://www.gdal.org/";
    license = licenses.mit;
    maintainers = with maintainers; teams.geospatial.members ++ [ marcweber dotlambda ];
    platforms = platforms.unix;
  };
})
