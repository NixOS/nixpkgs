{ lib
, appdirs
, buildPythonPackage
, fetchPypi
, packaging
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "path";
  version = "16.7.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-K0d/WIcDPzy+oc/YVT7mpqSY6yVAoZ9KoIKCKq3Oowo=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # creates a file, checks when it was last accessed/modified
    # AssertionError: assert 1650036414.0 == 1650036414.960688
    "test_utime"
  ];

  pythonImportsCheck = [
    "path"
  ];

  meta = with lib; {
    description = "Object-oriented file system path manipulation";
    homepage = "https://github.com/jaraco/path";
    changelog = "https://github.com/jaraco/path/blob/v${version}/NEWS.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
