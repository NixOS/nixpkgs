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
  pybind11,
}:

buildPythonPackage rec {
  pname = "python-mapnik";
  version = "4.1.3.unstable-2025-09-25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mapnik";
    repo = "python-mapnik";
    rev = "4b51d57911dc6a1a9f35c62c681fbdeb56fc69d4";
    hash = "sha256-oXxfLvmptW1v19vaUj11nGEcTHOrneBIea2+GB6uK48=";
    # Only needed for test data
    fetchSubmodules = true;
  };

  patches = [
    # python-mapnik seems to depend on having the mapnik src directory
    # structure available at build time. We just hardcode the paths.
    (replaceVars ./find-libmapnik.patch {
      libmapnik = "${mapnik}/lib";
    })
  ];

  stdenv = python.stdenv;

  build-system = [ setuptools ];

  nativeBuildInputs = [
    mapnik # for mapnik_config
    pkg-config
    pybind11
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
    broken = true;
  };
}
