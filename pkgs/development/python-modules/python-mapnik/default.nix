{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  isPyPy,
  python,
  setuptools,
  pillow,
  pycairo,
  pkg-config,
  boost,
  cairo,
  harfbuzz,
  icu,
  libjpeg,
  libpng,
  libtiff,
  libwebp,
  mapnik,
  proj,
  zlib,
  libxml2,
  sqlite,
  pytestCheckHook,
  sparsehash,
}:

buildPythonPackage rec {
  pname = "python-mapnik";
  version = "3.0.16-unstable-2024-02-22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mapnik";
    repo = "python-mapnik";
    rev = "5ab32f0209909cc98c26e1d86ce0c8ef29a9bf3d";
    hash = "sha256-OqijA1WcyBcyWO8gntqp+xNIaV1Jqa0n1eMDip2OCvY=";
    # Only needed for test data
    fetchSubmodules = true;
  };

  patches = [
    # python-mapnik seems to depend on having the mapnik src directory
    # structure available at build time. We just hardcode the paths.
    (replaceVars ./find-libmapnik.patch {
      libmapnik = "${mapnik}/lib";
    })
    # Use `std::optional` rather than `boost::optional`
    # https://github.com/mapnik/python-mapnik/commit/e9f88a95a03dc081826a69da67bbec3e4cccd5eb
    ./python-mapnik_std_optional.patch
  ];

  stdenv = python.stdenv;

  build-system = [ setuptools ];

  nativeBuildInputs = [
    mapnik # for mapnik_config
    pkg-config
  ];

  dependencies = [
    mapnik
    boost
    cairo
    harfbuzz
    icu
    libjpeg
    libpng
    libtiff
    libwebp
    proj
    zlib
    libxml2
    sqlite
    sparsehash
  ];

  propagatedBuildInputs = [
    pillow
    pycairo
  ];

  configureFlags = [ "XMLPARSER=libxml2" ];

  disabled = isPyPy;

  preBuild = ''
    export BOOST_PYTHON_LIB="boost_python${"${lib.versions.major python.version}${lib.versions.minor python.version}"}"
    export BOOST_THREAD_LIB="boost_thread"
    export BOOST_SYSTEM_LIB="boost_system"
    export PYCAIRO=true
    export XMLPARSER=libxml2
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    # import from $out
    rm -r mapnik
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Replace the hardcoded /tmp references with $TMPDIR
    sed -i "s,/tmp,$TMPDIR,g" test/python_tests/*.py
  '';

  # https://github.com/mapnik/python-mapnik/issues/255
  disabledTests = [
    "test_geometry_type"
    "test_passing_pycairo_context_pdf"
    "test_pdf_printing"
    "test_render_with_scale_factor"
    "test_raster_warping"
    "test_pycairo_svg_surface1"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "test_passing_pycairo_context_png"
    "test_passing_pycairo_context_svg"
    "test_pycairo_pdf_surface1"
    "test_pycairo_pdf_surface2"
    "test_pycairo_pdf_surface3"
    "test_pycairo_svg_surface2"
    "test_pycairo_svg_surface3"
  ];

  pythonImportsCheck = [ "mapnik" ];

  meta = {
    description = "Python bindings for Mapnik";
    homepage = "https://mapnik.org";
    license = lib.licenses.lgpl21Plus;
    teams = [ lib.teams.geospatial ];
  };
}
