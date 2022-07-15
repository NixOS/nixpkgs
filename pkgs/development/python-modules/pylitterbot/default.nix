{ lib
, authlib
, buildPythonPackage
, fetchFromGitHub
, httpx
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "pylitterbot";
  version = "2022.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "natekspencer";
    repo = pname;
    rev = version;
    sha256 = "sha256-iniSlsZVWdDuwM/6asX4xyVrtrQvt7wEBwDVutjCogU=";
  };

  propagatedBuildInputs = [
    authlib
    httpx
    pytz
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pylitterbot"
  ];

  meta = with lib; {
    description = "Python package for controlling a Litter-Robot";
    homepage = "https://github.com/natekspencer/pylitterbot";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
