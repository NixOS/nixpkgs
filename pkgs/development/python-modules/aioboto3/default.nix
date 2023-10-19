{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, poetry-dynamic-versioning
, aiobotocore
, chalice
, cryptography
, boto3
, pytestCheckHook
, pytest-asyncio
, requests
, aiofiles
, moto
, dill
}:

buildPythonPackage rec {
  pname = "aioboto3";
  version = "11.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "terrycain";
    repo = "aioboto3";
    rev = "v${version}";
    hash = "sha256-jU9sKhbUdVeOvOXQnXR/S/4sBwTNcQCc9ZduO+HDXho=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
    --replace poetry.masonry.api poetry.core.masonry.api \
    --replace "poetry>=0.12" "poetry-core>=0.12"
  '';

  nativeBuildInputs = [
    poetry-core
    poetry-dynamic-versioning
  ];

  propagatedBuildInputs = [
    aiobotocore
    boto3
  ];

  passthru.optional-dependencies = {
    chalice = [
      chalice
    ];
    s3cse = [
      cryptography
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    requests
    aiofiles
    moto
    dill
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [ "aioboto3" ];

  meta = with lib; {
    description = "Wrapper to use boto3 resources with the aiobotocore async backend";
    homepage = "https://github.com/terrycain/aioboto3";
    changelog = "https://github.com/terrycain/aioboto3/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
