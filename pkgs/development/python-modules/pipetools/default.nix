{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pipetools";
  version = "1.1.0";

  # Used github as the src since the pypi package does not include the tests
  src = fetchFromGitHub {
    owner = "0101";
    repo = pname;
    rev = "6cba9fadab07a16fd85eed16d5cffc609f84c62b";
    hash = "sha256-BoZFePQCQfz1dkct5p/WQLuXoNX3eLcnKf3Mf0fG6u8=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  propagatedBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "pipetools" ];

  meta = {
    description = "A library that enables function composition similar to using Unix pipes";
    homepage = "https://0101.github.io/pipetools/";
    license = lib.licenses.mit;
  };
}
