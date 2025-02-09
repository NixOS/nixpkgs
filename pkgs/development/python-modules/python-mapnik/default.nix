{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, substituteAll
, isPyPy
, python
, pillow
, pycairo
, pkg-config
, boost182
, cairo
, harfbuzz
, icu
, libjpeg
, libpng
, libtiff
, libwebp
, mapnik
, proj
, zlib
, libxml2
, sqlite
, nose
, pytestCheckHook
, stdenv
}:

buildPythonPackage rec {
  pname = "python-mapnik";
  version = "unstable-2020-09-08";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mapnik";
    repo = "python-mapnik";
    rev = "a2c2a86eec954b42d7f00093da03807d0834b1b4";
    hash = "sha256-GwDdrutJOHtW7pIWiUAiu1xucmRvp7YFYB3YSCrDsrY=";
    # Only needed for test data
    fetchSubmodules = true;
  };

  patches = [
    # https://github.com/mapnik/python-mapnik/issues/239
    (fetchpatch {
      url = "https://github.com/koordinates/python-mapnik/commit/318b1edac16f48a7f21902c192c1dd86f6210a44.patch";
      hash = "sha256-cfU8ZqPPGCqoHEyGvJ8Xy/bGpbN2vSDct6A3N5+I8xM=";
    })
    ./find-pycairo-with-pkg-config.patch
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
    boost182
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

  propagatedBuildInputs = [ pillow pycairo ];

  configureFlags = [
    "XMLPARSER=libxml2"
  ];

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

  preCheck = ''
    # import from $out
    rm -r mapnik
  '' + lib.optionalString stdenv.isDarwin ''
    # Replace the hardcoded /tmp references with $TMPDIR
    sed -i "s,/tmp,$TMPDIR,g" test/python_tests/*.py
  '';

  # https://github.com/mapnik/python-mapnik/issues/255
  disabledTests = [
    "test_adding_datasource_to_layer"
    "test_compare_map"
    "test_dataraster_coloring"
    "test_dataraster_query_point"
    "test_geometry_type"
    "test_good_files"
    "test_layer_init"
    "test_load_save_map"
    "test_loading_fontset_from_map"
    "test_normalizing_definition"
    "test_pdf_printing"
    "test_proj_antimeridian_bbox"
    "test_proj_transform_between_init_and_literal"
    "test_pycairo_pdf_surface1"
    "test_pycairo_svg_surface1"
    "test_query_tolerance"
    "test_raster_warping"
    "test_raster_warping_does_not_overclip_source"
    "test_render_points"
    "test_render_with_scale_factor"
    "test_style_level_comp_op"
    "test_style_level_image_filter"
    "test_that_coordinates_do_not_overflow_and_polygon_is_rendered_csv"
    "test_that_coordinates_do_not_overflow_and_polygon_is_rendered_memory"
    "test_transparency_levels"
    "test_visual_zoom_all_rendering1"
    "test_visual_zoom_all_rendering2"
    "test_wgs84_inverse_forward"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_passing_pycairo_context_pdf"
    "test_passing_pycairo_context_svg"
  ];

  pythonImportsCheck = [ "mapnik" ];

  meta = with lib; {
    description = "Python bindings for Mapnik";
    maintainers = with maintainers; [ ];
    homepage = "https://mapnik.org";
    license = licenses.lgpl21Plus;
  };
}
