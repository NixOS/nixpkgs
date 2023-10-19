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
  version = "6.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-mB9BEVqbHcoUaygIgrtqk20wMJkL+dWpbeyG5VP4+sg=";
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
