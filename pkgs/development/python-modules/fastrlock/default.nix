{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "fastrlock";
  version = "0.8.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "scoder";
    repo = "fastrlock";
    tag = "v${version}";
    hash = "sha256-NB/AR6g1ZP5Atc0zwZNuXLsxg8BM67rWnx3Q6Pb0k5k=";
  };

  nativeBuildInputs = [ cython ];

  # Todo: Check why the tests have an import error
  doCheck = false;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fastrlock" ];

  meta = with lib; {
    description = "RLock implementation for CPython";
    homepage = "https://github.com/scoder/fastrlock";
    license = licenses.mit;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
