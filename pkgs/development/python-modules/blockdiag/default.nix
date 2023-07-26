{ lib
, buildPythonPackage
, docutils
, fetchFromGitHub
, fetchpatch
, funcparserlib
, nose
, pillow
, ephem
, pythonOlder
, pytestCheckHook
, reportlab
, setuptools
, webcolors
, python
}:

buildPythonPackage rec {
  pname = "blockdiag";
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "blockdiag";
    repo = "blockdiag";
    rev = version;
    hash = "sha256-j8FoNUIJJOaahaol1MRPyY2jcPCEIlaAD4bmM2QKFFI=";
  };

  patches = [
    # https://github.com/blockdiag/blockdiag/pull/179
    (fetchpatch {
      name = "pillow-10-compatibility.patch";
      url = "https://github.com/blockdiag/blockdiag/commit/20d780cad84e7b010066cb55f848477957870165.patch";
      hash = "sha256-t1zWFzAsLL2EUa0nD4Eui4Y5AhAZLRmp/yC9QpzzeUA=";
    })
  ];

  propagatedBuildInputs = [
    setuptools
    funcparserlib
    pillow
    webcolors
    reportlab
    docutils
  ];

  nativeCheckInputs = [
    ephem
    nose
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "src/blockdiag/tests/"
  ];

  disabledTests = [
    # Test require network access
    "test_app_cleans_up_images"
  ];

  pythonImportsCheck = [
    "blockdiag"
  ];

  meta = with lib; {
    description = "Generate block-diagram image from spec-text file (similar to Graphviz)";
    homepage = "http://blockdiag.com/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
