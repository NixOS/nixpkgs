{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  types-setuptools,
}:

buildPythonPackage rec {
  pname = "requirements-parser";
  version = "0.11.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "madpah";
    repo = "requirements-parser";
    rev = "refs/tags/v${version}";
    hash = "sha256-o9IriQXa2Pd7s16IENqcWgi73XZQoXsbXU471V1CFaI=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    setuptools
    types-setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "requirements" ];

  meta = with lib; {
    description = "Pip requirements file parser";
    homepage = "https://github.com/davidfischer/requirements-parser";
    changelog = "https://github.com/madpah/requirements-parser/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
