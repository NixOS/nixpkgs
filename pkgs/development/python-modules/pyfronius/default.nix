{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyfronius";
  version = "0.6.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nielstron";
    repo = pname;
    rev = "release-${version}";
    sha256 = "sha256-z7sIDT6dxgLWcnpZ4NOp5Bz5C9xduwQJ3xmDfTyI+Gs=";
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
