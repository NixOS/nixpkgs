{
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  lib,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lektricowifi";
  version = "0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Lektrico";
    repo = "lektricowifi";
    tag = "v.${version}";
    hash = "sha256-GkRZ+fBjLtiZ3dPsn/xeJ7c0cVMY6SHIs+wqhmXXOTk=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "pydantic"
  ];

  dependencies = [
    async-timeout
    httpx
    pydantic
  ];

  pythonImportsCheck = [ "lektricowifi" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  # AttributeError: type object 'InfoForCharger' has no attribute 'from_dict'
  doCheck = false;

  meta = {
    description = "Communication with Lektrico's chargers";
    homepage = "https://github.com/Lektrico/lektricowifi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
