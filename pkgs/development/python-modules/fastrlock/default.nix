{ lib
, buildPythonPackage
, cython
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fastrlock";
  version = "0.8.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "scoder";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-2h+rhP/EVMG3IkJVkE74p4GeBTwV3BS7fUkKpwedr2k=";
  };

  nativeBuildInputs = [
    cython
  ];

  # Todo: Check why the tests have an import error
  doCheck = false;

  nativeCheckInputs = [
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
