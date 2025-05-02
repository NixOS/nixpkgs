{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch2
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

  patches = [
    (fetchpatch2 {
      # python 3.11+ compat
      url = "https://github.com/python-mechanize/mechanize/commit/1324b09b661aaac7d4cdc7e1e9d49e1c3851db2c.patch";
      hash = "sha256-d0Zuz6m2Uv8pnR8TC0L+AStS82rPPTpQrrjkCZnJliE=";
    })
  ];

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
