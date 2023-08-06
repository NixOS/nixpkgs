{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ci-py";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-R/6bLsXOKGxiJDZUvvOuvLp3usEhfg698qvvgOwBXYk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner', " ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ci"
  ];

  meta = with lib; {
    description = "Library for working with Continuous Integration services";
    homepage = "https://github.com/grantmcconnaughey/ci.py";
    changelog = "https://github.com/grantmcconnaughey/ci.py/blob/master/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
