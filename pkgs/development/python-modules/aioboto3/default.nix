{
  lib,
  aiobotocore,
  aiofiles,
  buildPythonPackage,
  chalice,
  cryptography,
  dill,
  fetchFromGitHub,
  moto,
  poetry-core,
  poetry-dynamic-versioning,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aioboto3";
  version = "13.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "terrycain";
    repo = "aioboto3";
    tag = "v${version}";
    hash = "sha256-o3PynPW6nPvbBrsw+HU2fJheVRpCHCb0EnJdmseorsE=";
  };

  pythonRelaxDeps = [
    "aiobotocore"
  ];

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    aiobotocore
    aiofiles
  ] ++ aiobotocore.optional-dependencies.boto3;

  optional-dependencies = {
    chalice = [ chalice ];
    s3cse = [ cryptography ];
  };

  nativeCheckInputs =
    [
      dill
      moto
      pytest-asyncio
      pytestCheckHook
    ]
    ++ moto.optional-dependencies.server
    ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "aioboto3" ];

  meta = {
    description = "Wrapper to use boto3 resources with the aiobotocore async backend";
    homepage = "https://github.com/terrycain/aioboto3";
    changelog = "https://github.com/terrycain/aioboto3/blob/${src.rev}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mbalatsko ];
  };
}
