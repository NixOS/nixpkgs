{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, pyjwt
, pytestCheckHook
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "homepluscontrol";
  version = "0.0.5";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "chemaaa";
    repo = pname;
    rev = version;
    sha256 = "1nd3a7nhh1xb70cdh2h2bimwbffvpc3457smyzr9fqkjwfbcrr93";
  };

  propagatedBuildInputs = [
    aiohttp
    pyjwt
    yarl
  ];

  checkInputs = [
    aioresponses
    pytestCheckHook
  ];

  pythonImportsCheck = [ "homepluscontrol" ];

  meta = with lib; {
    description = "Python API to interact with the Legrand Eliot Home and Control";
    homepage = "https://github.com/chemaaa/homepluscontrol";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
