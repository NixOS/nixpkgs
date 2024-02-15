{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub

, loguru
, poetry-core
, setuptools
}:

buildPythonPackage rec {
  pname = "mobi";
  version = "0.3.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "iscc";
    repo = "mobi";
    rev = "v${version}";
    hash = "sha256-g1L72MkJdrKQRsEdew+Qsn8LfCn8+cmj2pmY6s4nv2U=";
  };

  nativeBuildInputs = [
    setuptools
    poetry-core
  ];

  propagatedBuildInputs = [
    loguru
  ];

  pythonImportsCheck = [
    "mobi"
  ];

  meta = with lib; {
    description = "Library for unpacking unencrypted mobi files";
    homepage = "https://github.com/iscc/mobi";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}
