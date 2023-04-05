{ lib
, buildPythonPackage
, fetchFromGitLab
, poetry-core
, cssselect
, lxml
, numpy
, packaging
, pillow
, pygobject3
, pyserial
, scour
, gobject-introspection
, pytestCheckHook
, gtk3
}:

buildPythonPackage rec {
  pname = "inkex";
  version = "1.2.2";

  format = "pyproject";

  src = fetchFromGitLab {
    owner = "inkscape";
    repo = "extensions";
    rev = "EXTENSIONS_AT_INKSCAPE_${version}";
    hash = "sha256-jw7daZQTBxLHWOpjZkMYtP1vIQvd/eLgiktWqVSjEgU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"1.2.0"' '"${version}"' \
      --replace 'scour = "^0.37"' 'scour = ">=0.37"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    cssselect
    lxml
    numpy
    packaging
    pillow
    pygobject3
    pyserial
    scour
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
  ];

  disabledTestPaths = [
    # Fatal Python error: Segmentation fault
    "tests/test_inkex_gui.py"
    "tests/test_inkex_gui_listview.py"
    "tests/test_inkex_gui_window.py"
    # Failed to find pixmap 'image-missing' in /build/source/tests/data/
    "tests/test_inkex_gui_pixmaps.py"
  ];

  meta = {
    description = "Library for manipulating SVG documents which is the basis for Inkscape extensions";
    homepage = "https://gitlab.com/inkscape/extensions";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
