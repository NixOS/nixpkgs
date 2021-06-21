{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "enturclient";
  version = "0.2.1";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hfurubotten";
    repo = pname;
    rev = "v${version}";
    sha256 = "158xzv9c2drjgrdhfqm0xzx2d34v45gr5rnjfsi94scffvprgwrg";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "enturclient" ];

  meta = with lib; {
    description = "Python library for interacting with the Entur.org API";
    homepage = "https://github.com/hfurubotten/enturclient";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
