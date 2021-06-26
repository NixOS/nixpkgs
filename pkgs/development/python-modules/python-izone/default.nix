{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, aiohttp
, netifaces
, asynctest
, pytest-aiohttp
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-izone";
  version = "1.1.5";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "Swamp-Ig";
    repo = "pizone";
    rev = "v${version}";
    sha256 = "0ilvawlhyg5p08ri26zbcvgysrfsmza23scy4ijrx3jbc3669r2c";
  };

  propagatedBuildInputs = [
    aiohttp
    netifaces
  ];

  checkInputs = [
    asynctest
    pytest-aiohttp
    pytestCheckHook
  ];

  disabledTests = [
    # attempt network connection
    "test_fail_on_connect"
    "test_connection_lost"
    "test_ip_addr_change"
  ];

  pythonImportsCheck = [ "pizone" ];

  meta = with lib; {
    description = "A python interface to the iZone airconditioner controller";
    homepage = "https://github.com/Swamp-Ig/pizone";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
