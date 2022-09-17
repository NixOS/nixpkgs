{ lib
, aiosmtpd
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, hypothesis
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiosmtplib";
  version = "1.1.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cole";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-bo+u3I+ZX95UYkEam2TB6d6rvbYKa5Qu/9oNX5le478=";
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

  patches = [
    # Switch to poetry-core, https://github.com/cole/aiosmtplib/pull/183
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/cole/aiosmtplib/commit/3aba1c132d9454e05d4281f4c8aa618b4e1b783d.patch";
      hash = "sha256-KlA46gD6swfJ/3OLO3xWZWa66Gx1/izmUMQ60PQy0po=";
    })
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
