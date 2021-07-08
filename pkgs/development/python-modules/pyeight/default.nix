{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, isPy3k
}:

buildPythonPackage rec {
  pname = "pyeight";
  version = "0.1.9";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "mezz64";
    repo = "pyEight";
    rev = version;
    sha256 = "sha256-s1SOJOy1Bkufxh8TNkw/x4wrFewymgafz+p/zxPQcPk=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pyeight" ];

  meta = with lib; {
    description = "Python library to interface with the Eight Sleep API";
    homepage = "https://github.com/mezz64/pyEight";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
