{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "incomfort-client";
  version = "0.4.5";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zxdavb";
    repo = pname;
    rev = version;
    sha256 = "0r9f15fcjwhrq6ldji1dzbb76wsvinpkmyyaj7n55rl6ibnsyrwp";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "incomfortclient" ];

  meta = with lib; {
    description = "Python module to poll Intergas boilers via a Lan2RF gateway";
    homepage = "https://github.com/zxdavb/incomfort-client";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
