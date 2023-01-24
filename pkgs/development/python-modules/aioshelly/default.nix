{ lib
, aiohttp
, bluetooth-data-tools
, buildPythonPackage
, fetchFromGitHub
, orjson
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioshelly";
  version = "5.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-tsjHs1v5Yth5XToznCdAWoe70Lhxqh6Mq/MHKSYYg14=";
  };

  propagatedBuildInputs = [
    aiohttp
    bluetooth-data-tools
    orjson
  ];

  # Project has no test
  doCheck = false;

  pythonImportsCheck = [
    "aioshelly"
  ];

  meta = with lib; {
    description = "Python library to control Shelly";
    homepage = "https://github.com/home-assistant-libs/aioshelly";
    changelog = "https://github.com/home-assistant-libs/aioshelly/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
