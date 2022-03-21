{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyeight";
  version = "0.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mezz64";
    repo = "pyEight";
    rev = version;
    sha256 = "sha256-ERilZWroFaBCYjTfU7W0vegJaGibmJYVcgt0z84TPEI=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pyeight"
  ];

  meta = with lib; {
    description = "Python library to interface with the Eight Sleep API";
    homepage = "https://github.com/mezz64/pyEight";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
