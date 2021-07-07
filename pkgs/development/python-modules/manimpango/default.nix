{ lib
, buildPythonPackage
, pkg-config
, fetchPypi
, cairo
, pango
, pygobject3
, glib
, libintl
, harfbuzz
, cython
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "manimpango";
  version = "0.2.6";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "ManimPango";
    inherit version;
    sha256 = "64028b62b151bc80b047cc1757b27943498416dc4a85f073892a524b4d90ab41";
  };

  nativeBuildInputs = [
    pkg-config
    cython
  ];

  buildInputs = [
    harfbuzz
    glib
    cairo
    libintl
    pango
  ];

  propagatedBuildInputs = [
    pygobject3
  ];

  setupPyBuildFlags = [
    "-I${cairo.dev}/include/cairo"
    "-L${cairo.out}/lib"
    "-lcairo"
    "-lpangocairo-1.0"
  ];

  # pangocairo is part of normal cairo-package, so remove corresponding deps
  # from setup.py
  postPatch =''
    substituteInPlace setup.py \
      --replace "\"pangocairo-1.0\"," "" \
      --replace "_pkg_config = PKG_CONFIG(\"pangocairo\")" "_pkg_config = PKG_CONFIG(\"pango\")"
  '';

  # checks fail until manim is installed
  doCheck = false;

  pythonImportsCheck = [ "manimpango" ];

  meta = with lib; {
    description = "ManimPango is a C binding for Pango using Cython";
    longDescription = ''
      ManimPango is a C binding for Pango using Cython, which is internally
      used in Manim to render (non-LaTeX) text.
    '';
    homepage = "https://github.com/ManimCommunity/ManimPango";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ friedelino ];
  };
}
