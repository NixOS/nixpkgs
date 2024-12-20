{
  lib,
  aiosmtpd,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  trustme,
}:

buildPythonPackage rec {
  pname = "aiosmtplib";
  version = "3.0.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cole";
    repo = "aiosmtplib";
    rev = "refs/tags/v${version}";
    hash = "sha256-1GuxlgNvzVv6hEQY1Mkv7NxAoOik9gpIS90a6flfC+k=";
  };

  build-system = [ hatchling ];

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
