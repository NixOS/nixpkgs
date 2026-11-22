{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  #, pytestCheckHook
  pkg-config,
  gammu,
}:

buildPythonPackage rec {
  pname = "python-gammu";
  version = "3.5.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "gammu";
    repo = "python-gammu";
    rev = version;
    hash = "sha256-hSc3fGI/on/DoiZiuYxxJoqdl6wmb+ZjXL6EjMmMlKU=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gammu ];

  # Check with the next release if tests could be run with pytest
  # nativeCheckInputs = [ pytestCheckHook ];
  # Don't run tests for now
  doCheck = false;

  pythonImportsCheck = [ "gammu" ];

  meta = {
    description = "Python bindings for Gammu";
    homepage = "https://github.com/gammu/python-gammu/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
}
