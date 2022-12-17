{ lib
, buildPythonPackage
, fetchFromGitHub
, pytz
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "backports-datetime-fromisoformat";
  version = "2.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "movermeyer";
    repo = "backports.datetime_fromisoformat";
    rev = "refs/tags/v${version}";
    hash = "sha256-aHF3E/fLN+j/T4W9lvuVSMy6iRSEn+ARWmL01rY+ixs=";
  };

  checkInputs = [
    pytz
    unittestCheckHook
  ];

  pythonImportsCheck = [
    "backports.datetime_fromisoformat"
  ];

  meta = with lib; {
    changelog = "https://github.com/movermeyer/backports.datetime_fromisoformat/releases/tag/v${version}";
    description = "Backport of Python 3.11's datetime.fromisoformat";
    homepage = "https://github.com/movermeyer/backports.datetime_fromisoformat";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
