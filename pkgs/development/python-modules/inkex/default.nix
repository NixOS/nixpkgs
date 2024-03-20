{ lib
, buildPythonPackage
, inkscape
, fetchFromGitLab
, poetry-core
, cssselect
, lxml
, numpy
, packaging
, pillow
, pygobject3
, pyparsing
, pyserial
, scour
, gobject-introspection
, pytestCheckHook
, gtk3
}:

buildPythonPackage {
  pname = "inkex";
  inherit (inkscape) version;

  format = "pyproject";

  inherit (inkscape) src;

  nativeBuildInputs = [
    poetry-core
  ];

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

  disabledTests = [
    "test_extract_multiple"
    "test_lookup_and"
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
