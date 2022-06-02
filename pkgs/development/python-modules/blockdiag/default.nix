{ lib
, buildPythonPackage
, docutils
, fetchFromGitHub
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
    sha256 = "sha256-j8FoNUIJJOaahaol1MRPyY2jcPCEIlaAD4bmM2QKFFI=";
  };

  propagatedBuildInputs = [
    setuptools
    funcparserlib
    pillow
    webcolors
    reportlab
    docutils
  ];

  checkInputs = [
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
    maintainers = with maintainers; [ bjornfor SuperSandro2000 ];
  };
}
