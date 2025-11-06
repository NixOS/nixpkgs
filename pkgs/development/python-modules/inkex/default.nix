{
  lib,
  stdenv,
  buildPythonPackage,
  inkscape,
  poetry-core,
  cssselect,
  lxml,
  numpy,
  pillow,
  pygobject3,
  pyparsing,
  pyserial,
  scour,
  tinycss2,
  gobject-introspection,
  pytestCheckHook,
  gtk3,
}:

buildPythonPackage {
  pname = "inkex";
  inherit (inkscape) version;
  pyproject = true;

  inherit (inkscape) src;

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "lxml"
    "numpy"
  ];

  dependencies = [
    cssselect
    lxml
    numpy
    pillow
    pygobject3
    pyparsing
    pyserial
    scour
    tinycss2
  ];

  pythonImportsCheck = [ "inkex" ];

  nativeCheckInputs = [
    gobject-introspection
    pytestCheckHook
  ];

  checkInputs = [
    gtk3
  ];

  disabledTests = [
    "test_extract_multiple"
    "test_lookup_and"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin [
    "test_image_extract"
    "test_path_number_nodes"
    "test_plotter" # Hangs
  ];

  disabledTestPaths = [
    # Fatal Python error: Segmentation fault
    "tests/test_inkex_gui.py"
    "tests/test_inkex_gui_listview.py"
    "tests/test_inkex_gui_window.py"
    # Failed to find pixmap 'image-missing' in /build/source/tests/data/
    "tests/test_inkex_gui_pixmaps.py"
    # Fails with libxml2 >= 2.15 with "lxml.etree was compiled without Schematron support"
    "inkex/tester/test_inx_file.py"
    "tests/test_inkex_inx.py"
  ];

  postPatch = ''
    cd share/extensions

    substituteInPlace pyproject.toml \
      --replace-fail 'scour = "^0.37"' 'scour = ">=0.37"'
  '';

  meta = {
    description = "Library for manipulating SVG documents which is the basis for Inkscape extensions";
    homepage = "https://gitlab.com/inkscape/extensions";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
