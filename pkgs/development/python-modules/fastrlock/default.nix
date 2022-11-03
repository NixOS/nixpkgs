{ lib
, buildPythonPackage
, cython
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fastrlock";
  version = "0.8.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "scoder";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-KYJd1wGJo+z34cY0YfsRbpC9IsQY/VJqycGpMmLmaVk=";
  };

  nativeBuildInputs = [
    cython
  ];

  # Todo: Check why the tests have an import error
  doCheck = false;

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "fastrlock"
  ];

  meta = with lib; {
    description = "RLock implementation for CPython";
    homepage = "https://github.com/scoder/fastrlock";
    license = licenses.mit;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
