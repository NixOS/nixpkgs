{ lib
, aiosmtpd
, buildPythonPackage
, fetchFromGitHub
, hypothesis
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, trustme
}:

buildPythonPackage rec {
  pname = "aiosmtplib";
  version = "3.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cole";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-A9pvHj2riIHCd1F+ve6aLdbtl3tPPDovV1AZeWNeOEo=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    aiosmtpd
    hypothesis
    pytest-asyncio
    pytestCheckHook
    trustme
  ];

  pythonImportsCheck = [
    "aiosmtplib"
  ];

  meta = with lib; {
    description = "Module which provides a SMTP client";
    homepage = "https://github.com/cole/aiosmtplib";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
