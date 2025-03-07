{
  lib,
  aiosmtpd,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  trustme,
}:

buildPythonPackage rec {
  pname = "aiosmtplib";
  version = "3.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cole";
    repo = "aiosmtplib";
    rev = "refs/tags/v${version}";
    hash = "sha256-67Z+k+PBIGP2oGb/52dMtsapUsHufvFcX+wWiMj5Jsg=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [
    aiosmtpd
    hypothesis
    pytest-asyncio
    pytestCheckHook
    trustme
  ];

  pythonImportsCheck = [ "aiosmtplib" ];

  meta = with lib; {
    description = "Module which provides a SMTP client";
    homepage = "https://github.com/cole/aiosmtplib";
    changelog = "https://github.com/cole/aiosmtplib/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
