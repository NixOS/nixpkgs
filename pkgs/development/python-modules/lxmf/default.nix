{ lib
, buildPythonPackage
, fetchFromGitHub
, rns
, pythonOlder
}:

buildPythonPackage rec {
  pname = "lxmf";
  version = "0.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "lxmf";
    rev = "refs/tags/${version}";
    hash = "sha256-DmJcxbAVaNUTe1ulVmYeI0Kdtm0Lz83akjH4ttZsgZg=";
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
