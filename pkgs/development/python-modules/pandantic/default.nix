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
  version = "1.0.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "wesselhuising";
    repo = "pandantic";
    tag = version;
    hash = "sha256-lqd4aQiBMbATFMdftKQeTlqQ3MGrxm2shb7qil+84iA=";
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
    changelog = "https://github.com/wesselhuising/pandantic/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
