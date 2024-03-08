{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, xmltodict
}:

buildPythonPackage rec {
  pname = "aioeagle";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = version;
    sha256 = "117nb50cxwrixif2r6fxmr9v0jxkcamm816v48hbhyc660w6xvk4";
  };

  propagatedBuildInputs = [
    aiohttp
    xmltodict
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aioeagle" ];

  meta = with lib; {
    description = "Python library to control EAGLE-200";
    homepage = "https://github.com/home-assistant-libs/aioeagle";
    changelog = "https://github.com/home-assistant-libs/aioshelly/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
