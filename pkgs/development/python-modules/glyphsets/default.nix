{ lib
, buildPythonPackage
, fetchPypi
, defcon
, fonttools
, gflanguages
, glyphslib
, pytestCheckHook
, pyyaml
, requests
, setuptools
, setuptools-scm
, unicodedata2
}:

buildPythonPackage rec {
  pname = "glyphsets";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fa+W1IGIZcn1P1xNKm1Yb/TOuf4QdDVnIvlDkOLOcLY=";
  };

  dependencies = [
    defcon
    fonttools
    gflanguages
    glyphslib
    pyyaml
    requests
    setuptools
    unicodedata2
  ];
  build-system = [
    setuptools-scm
  ];

  doCheck = true;
  nativeCheckInputs = [
    pytestCheckHook
  ];
  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';
  disabledTests = [
    # This "test" just tries to connect to PyPI and look for newer releases. Not needed.
    "test_dependencies"
  ];

  meta = with lib; {
    description = "Google Fonts glyph set metadata";
    mainProgram = "glyphsets";
    homepage = "https://github.com/googlefonts/glyphsets";
    license = licenses.asl20;
    maintainers = with maintainers; [ danc86 ];
  };
}
