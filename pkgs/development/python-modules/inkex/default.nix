{
  lib,
  stdenv,
  buildPythonPackage,
  inkscape,
  fetchpatch,
  poetry-core,
  cssselect,
  lxml,
  numpy,
  packaging,
  pillow,
  pygobject3,
  pyparsing,
  pyserial,
  scour,
  gobject-introspection,
  pytestCheckHook,
  gtk3,
}:

buildPythonPackage {
  pname = "inkex";
  inherit (inkscape) version;

  format = "pyproject";

  inherit (inkscape) src;

  patches = [
    # Fix “distribute along path” test with Python 3.12.
    # https://gitlab.com/inkscape/extensions/-/issues/580
    (fetchpatch {
      url = "https://gitlab.com/inkscape/extensions/-/commit/c576043c195cd044bdfc975e6367afb9b655eb14.patch";
      extraPrefix = "share/extensions/";
      stripLen = 1;
      hash = "sha256-D9HxBx8RNkD7hHuExJqdu3oqlrXX6IOUw9m9Gx6+Dr8=";
    })
  ];

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    cssselect
    lxml
    numpy
    pygobject3
    pyserial
  ];

  pythonImportsCheck = [ "inkex" ];

  nativeCheckInputs = [
    gobject-introspection
    pytestCheckHook
  ];

  checkInputs = [
    gtk3
    packaging
    pillow
    pyparsing
    scour
  ];

  disabledTests =
    [
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
  ];

  postPatch = ''
    cd share/extensions

    substituteInPlace pyproject.toml \
      --replace-fail 'scour = "^0.37"' 'scour = ">=0.37"' \
      --replace-fail 'lxml = "^4.5.0"' 'lxml = "^4.5.0 || ^5.0.0"'
  '';

  meta = {
    description = "Library for manipulating SVG documents which is the basis for Inkscape extensions";
    homepage = "https://gitlab.com/inkscape/extensions";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
