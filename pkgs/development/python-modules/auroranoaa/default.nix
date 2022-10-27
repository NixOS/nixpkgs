{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "auroranoaa";
  version = "0.0.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "djtimca";
    repo = "aurora-api";
    rev = version;
    sha256 = "0bh8amixkg3xigwh3ryra22x6kzhbdassmf1iqv20lhbvzmsqjv0";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "auroranoaa" ];

  meta = with lib; {
    description = "Python wrapper for the Aurora API";
    homepage = "https://github.com/djtimca/aurora-api";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
