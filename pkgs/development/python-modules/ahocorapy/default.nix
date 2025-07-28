{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ahocorapy";
  version = "1.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abusix";
    repo = "ahocorapy";
    tag = version;
    hash = "sha256-ynVkDnrZ12dpNPoKfUdw0/X06aORFkmXFMVH9u0Payo=";
  };

  build-system = [ setuptools ];

  pythonRemoveDeps = [ "future" ];

  pythonImportsCheck = [ "ahocorapy" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  enabledTestPaths = [
    "tests/ahocorapy_test.py"
  ];

  meta = {
    changelog = "https://github.com/abusix/ahocorapy/blob/${src.tag}/CHANGELOG";
    description = "Pure python Aho-Corasick library";
    homepage = "https://github.com/abusix/ahocorapy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
