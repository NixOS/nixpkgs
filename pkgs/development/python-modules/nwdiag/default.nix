{ lib
, blockdiag
, fetchFromGitHub
, buildPythonPackage
, nose
, pytestCheckHook
, setuptools
, pythonOlder
, nwdiag
, testVersion
}:

buildPythonPackage rec {
  pname = "nwdiag";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "blockdiag";
    repo = pname;
    rev = version;
    sha256 = "sha256-PWLFJhXQeuUQQpGkXN2pEJs/1WECpJpUqWbGH3150TI=";
  };

  propagatedBuildInputs = [
    blockdiag
    setuptools
  ];

  checkInputs = [
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

  passthru.tests.version = testVersion { package = nwdiag; };

  meta = with lib; {
    description = "Generate network-diagram image from spec-text file (similar to Graphviz)";
    homepage = "http://blockdiag.com/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
