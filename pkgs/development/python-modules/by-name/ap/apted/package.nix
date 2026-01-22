{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage {
  pname = "apted";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JoaoFelipe";
    repo = "apted";
    rev = "828b3e3f4c053f7d35f0b55b0d5597e8041719ac";
    hash = "sha256-h8vJDC5TPpyhDxm1sHiXPegPB2eorEgyrNqzQOzSge8=";
  };

  build-system = [ setuptools ];
  pythonImportsCheck = [ "apted" ];
  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    description = "APTED algorithm for the Tree Edit Distance";
    homepage = "https://github.com/JoaoFelipe/apted";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.McSinyx ];
  };
}
