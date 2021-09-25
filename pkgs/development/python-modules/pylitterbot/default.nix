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
  version = "2021.9.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "natekspencer";
    repo = pname;
    rev = version;
    sha256 = "sha256-S25x9k6vBwnmJq15y5PVUWaTujT9UNHvgIX9uH+N8dY=";
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
