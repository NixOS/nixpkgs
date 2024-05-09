{ lib
, buildPythonPackage
, fetchPypi
, defcon
, fonttools
, gflanguages
, glyphslib
, pytestCheckHook
, requests
, setuptools
, setuptools-scm
, unicodedata2
}:

buildPythonPackage rec {
  pname = "glyphsets";
  version = "0.6.19";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vO9gzMCXPlkkM9MtRhlulAnQi6uZMtJU1NqcP8w6tCo=";
  };

  dependencies = [
    defcon
    fonttools
    gflanguages
    glyphslib
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
