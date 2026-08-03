{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ipython,
  numpy,
  pandas,
  pytestCheckHook,
  requests,
  responses,
  setuptools,
  tqdm,
}:

buildPythonPackage rec {
  pname = "cdcs";
  version = "0.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "pycdcs";
    tag = "v${version}";
    hash = "sha256-P6fFL9yqnVbeUNBejnTcFowcf9xZP6XwheHwNUZKKlM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    ipython
    numpy
    pandas
    requests
    tqdm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "cdcs" ];

  disabledTests = [
    # Assertion errors
    "test_get_workspaces_v2"
    "test_get_workspaces_v3"
  ];

  meta = {
    description = "Python client for performing REST calls to configurable data curation system (CDCS) databases";
    homepage = "https://github.com/usnistgov/pycdcs";
    changelog = "https://github.com/usnistgov/pycdcs/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
