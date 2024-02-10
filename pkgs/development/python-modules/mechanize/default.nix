{ lib
, buildPythonPackage
, fetchPypi
, html5lib
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "mechanize";
  version = "0.4.9";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aaXtsJYvkh6LEINzaMIkLYrQSfC5H/aZzn9gG/xDFSE=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    html5lib
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mechanize"
  ];

  disabledTestPaths = [
    # Tests require network access
    "test/test_urllib2_localnet.py"
    "test/test_functional.py"
  ];

  disabledTests = [
    # Tests require network access
    "test_pickling"
    "test_password_manager"
  ];

  meta = with lib; {
    description = "Stateful programmatic web browsing in Python";
    homepage = "https://github.com/python-mechanize/mechanize";
    changelog = "https://github.com/python-mechanize/mechanize/blob/v${version}/ChangeLog";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
