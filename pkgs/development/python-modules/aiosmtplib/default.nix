{ lib
, aiosmtpd
, buildPythonPackage
, fetchFromGitHub
, hypothesis
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiosmtplib";
  version = "1.1.7";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cole";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ZVNYMVg2qeMoSojmPllvJLv2Xm5IYN9h5N13oHPFXSk=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
    aiosmtpd
    hypothesis
    pytest-asyncio
    pytestCheckHook
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
