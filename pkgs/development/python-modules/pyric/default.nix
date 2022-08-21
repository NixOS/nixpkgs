{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyric";
  version = "0.1.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "wraith-wireless";
    repo = pname;
    rev = version;
    hash = "sha256-NAuGgYViMYxzJDQw666cT1WaaNNKh3Ik/tNYJ/tPjbY=";
  };

  # Tests are outdated
  doCheck = false;

  pythonImportsCheck = [
    "pyric"
  ];

  meta = with lib; {
    description = "Python Radio Interface Controller";
    homepage = "https://github.com/wraith-wireless/PyRIC";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
