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
  version = "1.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sabuhish";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ttVzjmMZe1iWn2J7N5pcol4GFnKv3CB3DOQkZU2HnHg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "1.2.5"' 'version = "${version}"' \
      --replace 'aiosmtplib = "^2.0"' 'aiosmtplib = "*"' \
      --replace 'pydantic = "^1.8"' 'pydantic = "*"' \
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

  nativeCheckInputs = [
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
    changelog = "https://github.com/sabuhish/fastapi-mail/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
