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
  version = "0.0.61";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "chemaaa";
    repo = pname;
    rev = version;
    sha256 = "1g61xj417dz1nz5g5ic8rs34fp424zvbgsymry1zldg3gskaqgvk";
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
