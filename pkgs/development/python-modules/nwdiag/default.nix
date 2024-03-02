{ lib
, blockdiag
, fetchFromGitHub
, buildPythonPackage
, nose
, pytestCheckHook
, setuptools
, pythonOlder
}:

buildPythonPackage rec {
  pname = "nwdiag";
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "blockdiag";
    repo = pname;
    rev = version;
    hash = "sha256-uKrdkXpL5YBr953sRsHknYg+2/WwrZmyDf8BMA2+0tU=";
  };

  propagatedBuildInputs = [
    blockdiag
    setuptools
  ];

  nativeCheckInputs = [
    nose
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "src/nwdiag/tests/"
  ];

  disabledTests = [
    # UnicodeEncodeError: 'latin-1' codec can't encode...
    "test_setup_inline_svg_is_true_with_multibytes"
  ];

  pythonImportsCheck = [
    "nwdiag"
  ];

  meta = with lib; {
    description = "Generate network-diagram image from spec-text file (similar to Graphviz)";
    homepage = "http://blockdiag.com/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
