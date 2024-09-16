{
  lib,
  aioredis,
  aiosmtplib,
  blinker,
  buildPythonPackage,
  email-validator,
  fakeredis,
  fastapi,
  fetchFromGitHub,
  httpx,
  jinja2,
  poetry-core,
  pydantic,
  pydantic-settings,
  pytest-asyncio,
  pytestCheckHook,
  python-multipart,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "fastapi-mail";
  version = "1.4.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sabuhish";
    repo = "fastapi-mail";
    rev = "refs/tags/${version}";
    hash = "sha256-2iTZqZIxlt1GKhElasTcnys18UbNNDwHoZziHBOIGBo=";
  };

  pythonRelaxDeps = [
    "aiosmtplib"
    "pydantic"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "1.2.5"' 'version = "${version}"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aioredis
    aiosmtplib
    blinker
    email-validator
    fakeredis
    fastapi
    httpx
    jinja2
    pydantic
    pydantic-settings
    python-multipart
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Tests require access to /etc/resolv.conf
    "test_default_checker"
    "test_redis_checker"
  ];

  pythonImportsCheck = [ "fastapi_mail" ];

  meta = with lib; {
    description = "Module for sending emails and attachments";
    homepage = "https://github.com/sabuhish/fastapi-mail";
    changelog = "https://github.com/sabuhish/fastapi-mail/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
