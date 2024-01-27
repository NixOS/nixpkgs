{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  jsonschema,
  pytest,
  pyyaml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-workflow";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LUMC";
    repo = "pytest-workflow";
    rev = "v${version}";
    hash = "sha256-ztR4TW41qVAnCLXPUsWaiMuD1ESL0Kvd5KAsOf8tcE0=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [
    jsonschema
    pyyaml
  ];

  pythonImportsCheck = [ "pytest_workflow" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Configure workflow/pipeline tests using yaml files";
    homepage = "https://github.com/LUMC/pytest-workflow";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ edmundmiller ];
  };
}
