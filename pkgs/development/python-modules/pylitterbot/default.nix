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
  version = "2021.7.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "natekspencer";
    repo = pname;
    rev = version;
    sha256 = "0hnjqj9n2sq1jhiwdrw2aayhyz94cwjxniiak2h1nxh2q0nzigh3";
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

  pythonImportsCheck = [ "pylitterbot" ];

  meta = with lib; {
    description = "Python package for controlling a Litter-Robot";
    homepage = "https://github.com/natekspencer/pylitterbot";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
