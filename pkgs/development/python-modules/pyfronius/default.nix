{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyfronius";
  version = "0.5.3";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nielstron";
    repo = pname;
    rev = version;
    sha256 = "sha256-AtCpraIYNrEkTygtLMivrXfKCKVKIIUCDo3GYFpg8fk=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyfronius" ];

  meta = with lib; {
    description = "Python module to communicate with Fronius Symo";
    homepage = "https://github.com/nielstron/pyfronius";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
