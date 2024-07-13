{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  substituteAll,
  isPyPy,
  python,
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
  nose,
  pytestCheckHook,
  darwin,
  sparsehash,
}:

buildPythonPackage rec {
  pname = "python-mapnik";
  version = "3.0.16-unstable-2024-02-22";
  format = "setuptools";

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
    (substituteAll {
      src = ./find-libmapnik.patch;
      libmapnik = "${mapnik}/lib";
    })
    # Use `std::optional` rather than `boost::optional`
    # https://github.com/mapnik/python-mapnik/commit/e9f88a95a03dc081826a69da67bbec3e4cccd5eb
    ./python-mapnik_std_optional.patch
  ];

  stdenv = if python.stdenv.isDarwin then darwin.apple_sdk_11_0.stdenv else python.stdenv;

  nativeBuildInputs = [
    mapnik # for mapnik_config
    pkg-config
  ];

  buildInputs = [
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

  nativeCheckInputs = [
    nose
    pytestCheckHook
  ];

  preCheck =
    ''
      # import from $out
      rm -r mapnik
    ''
    + lib.optionalString stdenv.isDarwin ''
      # Replace the hardcoded /tmp references with $TMPDIR
      sed -i "s,/tmp,$TMPDIR,g" test/python_tests/*.py
    '';

  # https://github.com/mapnik/python-mapnik/issues/255
  disabledTests = [
    "test_geometry_type"
    "test_passing_pycairo_context_pdf"
    "test_pdf_printing"
    "test_render_with_scale_factor"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_passing_pycairo_context_png"
    "test_passing_pycairo_context_svg"
    "test_pycairo_pdf_surface1"
    "test_pycairo_pdf_surface2"
    "test_pycairo_pdf_surface3"
    "test_pycairo_svg_surface1"
    "test_pycairo_svg_surface2"
    "test_pycairo_svg_surface3"
  ];

  pythonImportsCheck = [ "mapnik" ];

  meta = with lib; {
    description = "Python bindings for Mapnik";
    maintainers = with maintainers; [ ];
    homepage = "https://mapnik.org";
    license = licenses.lgpl21Plus;
  };
}
