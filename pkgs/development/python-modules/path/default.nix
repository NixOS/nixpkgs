{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi

# build time
, setuptools-scm

# tests
, pytestCheckHook
, appdirs
, packaging
}:

buildPythonPackage rec {
  pname = "path";
  version = "16.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vqOBbh1U9OM6rHjSAxoLDtL5XmnbhbRdUfF9+XBx2mk=";
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
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
