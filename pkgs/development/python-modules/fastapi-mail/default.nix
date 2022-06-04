{ lib
, aioredis
, aiosmtplib
, blinker
, buildPythonPackage
, email_validator
, fakeredis
, fastapi
, fetchFromGitHub
, httpx
, jinja2
, poetry-core
, pydantic
, pytest-asyncio
, pytestCheckHook
, python-multipart
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fastapi-mail";
  version = "1.0.8";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sabuhish";
    repo = pname;
    rev = version;
    hash = "sha256-PkA7qkdDUd7mrtvb6IbCzFRq6X0M3iKY+FKuNConJ5A=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aioredis
    aiosmtplib
    blinker
    email_validator
    fakeredis
    fastapi
    httpx
    jinja2
    pydantic
    python-multipart
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Tests require access to /etc/resolv.conf
    "test_default_checker"
    "test_redis_checker"
  ];

  pythonImportsCheck = [
    "fastapi_mail"
  ];

  meta = with lib; {
    description = "Module for sending emails and attachments";
    homepage = "https://github.com/sabuhish/fastapi-mail";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
