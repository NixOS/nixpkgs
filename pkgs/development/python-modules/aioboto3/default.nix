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
  version = "14.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "terrycain";
    repo = "aioboto3";
    tag = "v${version}";
    hash = "sha256-RzaMsJtGvC6IILgwj09kymw+Hv3gjyBf2PHBzYC9itE=";
  };

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

  disabledTests = [
    "test_patches"
  ];

  pythonImportsCheck = [ "aioboto3" ];

  meta = {
    description = "Wrapper to use boto3 resources with the aiobotocore async backend";
    homepage = "https://github.com/terrycain/aioboto3";
    changelog = "https://github.com/terrycain/aioboto3/blob/${src.rev}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mbalatsko ];
  };
}
