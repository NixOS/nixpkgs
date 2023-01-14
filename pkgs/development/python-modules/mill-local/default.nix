{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mill-local";
  version = "0.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyMillLocal";
    rev = "refs/tags/${version}";
    hash = "sha256-u7TidHD0NzZ1JxYoCWviIXSsXojJHvVNg07eDBFQuls=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "mill_local"
  ];

  meta = with lib; {
    description = "Python module to communicate locally with Mill heaters";
    homepage = "https://github.com/Danielhiversen/pyMillLocal";
    changelog = "https://github.com/Danielhiversen/pyMillLocal/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
