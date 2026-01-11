{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytest-logdog";
  version = "0.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ods";
    repo = "pytest-logdog";
    rev = version;
    hash = "sha256-Tmoq+KAGzn0MMj29rukDfAc4LSIwC8DoMTuBAppV32I=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_logdog" ];

  meta = {
    description = "Pytest plugin to test logging";
    homepage = "https://github.com/ods/pytest-logdog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
