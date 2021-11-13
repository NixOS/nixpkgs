{ lib
, aiohttp
, asynctest
, buildPythonPackage
, certifi
, fetchFromGitHub
, pythonOlder
, coverage
}:

buildPythonPackage rec {
  pname = "crownstone-sse";
  version = "2.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "crownstone";
    repo = "crownstone-lib-python-sse";
    rev = version;
    sha256 = "0rrr92j8pi5annrfa22k1hggsyyacl9asi9i8yrj4jqdjvwjn2gc";
  };

  propagatedBuildInputs = [
    aiohttp
    asynctest
    certifi
  ];

  # Tests are only providing coverage
  doCheck = false;

  pythonImportsCheck = [
    "crownstone_sse"
  ];

  meta = with lib; {
    description = "Python module for listening to Crownstone SSE events";
    homepage = "https://github.com/crownstone/crownstone-lib-python-sse";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
