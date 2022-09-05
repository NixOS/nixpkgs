{ lib
, aioredis
, aiosmtplib
, blinker
, buildPythonPackage
, email-validator
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
  version = "1.1.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sabuhish";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-eQVDPkoRWlzCLwsOh+ksYniRyg02fhda6ys5QMqeLM0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'fastapi = "^0.75.0"' 'fastapi = "*"' \
      --replace 'httpx = "^0.22.0"' 'httpx = "*"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aioredis
    aiosmtplib
    blinker
    email-validator
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
