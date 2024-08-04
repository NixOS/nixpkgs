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
  requests,
}:

buildPythonPackage rec {
  pname = "aioboto3";
  version = "12.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "terrycain";
    repo = "aioboto3";
    rev = "refs/tags/v${version}";
    hash = "sha256-GDuxy/V+j0LRJ2lbcRHMEAga+pdCbYIWhEt3ItrHMB4=";
  };

  nativeBuildInputs = [
    poetry-core
    poetry-dynamic-versioning
  ];

  pythonRelaxDeps = [ "aiobotocore" ];

  propagatedBuildInputs = [ aiobotocore ] ++ aiobotocore.optional-dependencies.boto3;

  passthru.optional-dependencies = {
    chalice = [ chalice ];
    s3cse = [ cryptography ];
  };

  nativeCheckInputs = [
    aiofiles
    dill
    moto
    pytest-asyncio
    pytestCheckHook
    requests
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [ "aioboto3" ];

  disabledTests = [
    # Our moto package is not ready to support more tests
    "encrypt_decrypt_aes_cbc"
    "test_chalice_async"
    "test_dynamo"
    "test_flush_doesnt_reset_item_buffer"
    "test_kms"
    "test_s3"
  ];

  meta = with lib; {
    description = "Wrapper to use boto3 resources with the aiobotocore async backend";
    homepage = "https://github.com/terrycain/aioboto3";
    changelog = "https://github.com/terrycain/aioboto3/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
