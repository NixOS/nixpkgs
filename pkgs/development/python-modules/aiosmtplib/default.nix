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
  version = "2.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cole";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Wo9WH3fwGN1upLAyj6aThxpQE7hortISjaCATTPee40=";
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
