{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyfronius";
  version = "0.7.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nielstron";
    repo = pname;
    rev = "release-${version}";
    sha256 = "1xwx0c1dp2374bwigzwhvcj4577vrxyhn6i5zv73k9ydc7w1xgyz";
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
