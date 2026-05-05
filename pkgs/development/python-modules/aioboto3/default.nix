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
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "aioboto3";
  version = "15.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "terricain";
    repo = "aioboto3";
    tag = "v${version}";
    hash = "sha256-H/hAfFyBfeBoR6nW0sv3/AzFPATUl2uJ+JbzNB5xemo=";
  };

  # https://github.com/terricain/aioboto3/pull/377
  patches = [ ./boto3-compat.patch ];

  pythonRelaxDeps = [
    "aiobotocore"
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aiobotocore
    aiofiles
  ]
  ++ aiobotocore.optional-dependencies.boto3;

  optional-dependencies = {
    chalice = [ chalice ];
    s3cse = [ cryptography ];
  };

  nativeCheckInputs = [
    dill
    moto
    pytest-asyncio
    pytestCheckHook
  ]
  ++ moto.optional-dependencies.server
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  disabledTests = [
    "test_patches"
  ]
  ++ [
    # DynamoDB tests fail with aiobotocore 3.x due to HTTP header issue with moto:
    # "Duplicate 'Server' header found" - same issue as aiobotocore disables
    "test_dynamo_resource_query"
    "test_dynamo_resource_put"
    "test_dynamo_resource_batch_write_flush_on_exit_context"
    "test_dynamo_resource_batch_write_flush_amount"
    "test_flush_doesnt_reset_item_buffer"
    "test_dynamo_resource_property"
    "test_dynamo_resource_waiter"
  ];

  pythonImportsCheck = [ "aioboto3" ];

  meta = {
    description = "Wrapper to use boto3 resources with the aiobotocore async backend";
    homepage = "https://github.com/terricain/aioboto3";
    changelog = "https://github.com/terricain/aioboto3/blob/${src.rev}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mbalatsko ];
  };
}
