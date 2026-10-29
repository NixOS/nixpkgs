{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  fetchFromGitHub,
  hatchling,
  uv-dynamic-versioning,
  aiohttp,
  attrs,
  defusedxml,
  serialx,
  pytest-asyncio,
  pytest-aiohttp,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "arcam-fmj";
  version = "3.0.1.post1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "elupus";
    repo = "arcam_fmj";
    tag = version;
    hash = "sha256-hq1+RRF7ZQndsFNw+A6gLpLS2OCuMmjnCoYopSk6XiM=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    aiohttp
    attrs
    defusedxml
    serialx
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-aiohttp
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "arcam.fmj"
    "arcam.fmj.client"
    "arcam.fmj.state"
    "arcam.fmj.utils"
  ];

  meta = {
    description = "Python library for speaking to Arcam receivers";
    mainProgram = "arcam-fmj";
    homepage = "https://github.com/elupus/arcam_fmj";
    changelog = "https://github.com/elupus/arcam_fmj/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
