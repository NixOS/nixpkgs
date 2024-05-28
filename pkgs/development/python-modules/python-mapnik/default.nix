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
  stdenv,
}:

buildPythonPackage rec {
  pname = "python-mapnik";
  version = "unstable-2023-02-23";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mapnik";
    repo = "python-mapnik";
    # Use proj6 branch in order to support Proj >= 6 (excluding commits after 2023-02-23)
    # https://github.com/mapnik/python-mapnik/compare/master...proj6
    rev = "687b2c72a24c59d701d62e4458c380f8c54f0549";
    hash = "sha256-q3Snd3K/JndckwAVwSKU+kFK5E1uph78ty7mwVo/7Ik=";
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
  ];

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
    "test_marker_ellipse_render1"
    "test_marker_ellipse_render2"
    "test_normalizing_definition"
    "test_passing_pycairo_context_pdf"
    "test_pdf_printing"
    "test_visual_zoom_all_rendering2"
    "test_wgs84_inverse_forward"
  ] ++ lib.optionals stdenv.isDarwin [ "test_passing_pycairo_context_svg" ];

  pythonImportsCheck = [ "mapnik" ];

  meta = with lib; {
    description = "Python bindings for Mapnik";
    maintainers = with maintainers; [ ];
    homepage = "https://mapnik.org";
    license = licenses.lgpl21Plus;
  };
}
