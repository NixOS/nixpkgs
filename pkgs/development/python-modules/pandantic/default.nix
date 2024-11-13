{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  multiprocess,
  pandas-stubs,
  pandas,
  poetry-core,
  pydantic,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pandantic";
  version = "0.3.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "wesselhuising";
    repo = "pandantic";
    rev = "refs/tags/${version}";
    hash = "sha256-JRhnDVRYX0OV/dZkfqNoS2qFcoHOZHm9QZphF/JhgxM=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    multiprocess
    pandas
    pandas-stubs
    pydantic
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pandantic" ];

  meta = {
    description = "Module to enriche the Pydantic BaseModel class";
    homepage = "https://github.com/wesselhuising/pandantic";
    changelog = "https://github.com/wesselhuising/pandantic/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
