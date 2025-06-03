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
  version = "0.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "pycdcs";
    tag = "v${version}";
    hash = "sha256-u3txoe8ZfofMqhDB1ZhNF0mq9fYgwotRguVUezhDvwk=";
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

  meta = {
    description = "Python client for performing REST calls to configurable data curation system (CDCS) databases";
    homepage = "https://github.com/usnistgov/pycdcs";
    changelog = "https://github.com/usnistgov/pycdcs/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
