{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "fuzzyfinder";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "amjith";
    repo = "fuzzyfinder";
    rev = "refs/tags/v${version}";
    hash = "sha256-QWUABljgtzsZONl1klCrxEh0tPYodMOXokEb3YvWsyg=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fuzzyfinder" ];

  meta = with lib; {
    changelog = "https://github.com/amjith/fuzzyfinder/blob/${src.rev}/CHANGELOG.rst";
    description = "Fuzzy Finder implemented in Python";
    homepage = "https://github.com/amjith/fuzzyfinder";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
