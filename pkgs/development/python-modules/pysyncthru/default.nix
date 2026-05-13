{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  demjson3,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pysyncthru";
  version = "0.10.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "nielstron";
    repo = "pysyncthru";
    tag = version;
    hash = "sha256-IJfj65p80Q4LwWkGV0A0QPtK2+FPkNVz9/WaNGzgTy8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    demjson3
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pysyncthru" ];

  meta = {
    description = "Automated JSON API based communication with Samsung SyncThru Web Service";
    homepage = "https://github.com/nielstron/pysyncthru";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
