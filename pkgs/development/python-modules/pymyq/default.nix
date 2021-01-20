{ lib
, aiodns
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pymyq";
  version = "2.0.14";

  src = fetchFromGitHub {
    owner = "arraylabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "18825b9c6qk4zcvva79hpg6098z4zqxyapnqmjsli23npw0zh67w";
  };

  propagatedBuildInputs = [
    aiodns
    aiohttp
    async-timeout
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pymyq" ];

  meta = with lib; {
    description = "Python wrapper for MyQ API";
    homepage = "https://github.com/arraylabs/pymyq";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
