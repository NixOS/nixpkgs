{ lib
, buildPythonPackage
, fetchFromGitHub
, rns
, pythonOlder
}:

buildPythonPackage rec {
  pname = "lxmf";
  version = "0.1.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "lxmf";
    rev = version;
    hash = "sha256-kWawKlEAnn/uNjM2TT2aVW2V4M0+S/1Ysrw/muJhC0s=";
  };

  propagatedBuildInputs = [
    rns
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "LXMF"
  ];

  meta = with lib; {
    description = "Lightweight Extensible Message Format for Reticulum";
    homepage = "https://github.com/markqvist/lxmf";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
