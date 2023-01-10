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
  version = "2.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cole";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Py/44J9J8FdrsSpEM2/DR2DQH8x8Ub7y0FPIN2gcmmA=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
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
