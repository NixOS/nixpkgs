{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "linknlink";
  version = "0.1.9";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "xuanxuan000";
    repo = "python-linknlink";
    rev = "refs/tags/${version}";
    hash = "sha256-msKunZsAxA9xpCJmG4MVXuJDMEqrCeShvAqOw8zjSPM=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cryptography
  ];

  pythonImportsCheck = [
    "linknlink"
  ];

  # Module has no test
  doCheck = false;

  meta = with lib; {
    description = "Module and CLI for controlling Linklink devices locally";
    homepage = "https://github.com/xuanxuan000/python-linknlink";
    changelog = "https://github.com/xuanxuan000/python-linknlink/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
