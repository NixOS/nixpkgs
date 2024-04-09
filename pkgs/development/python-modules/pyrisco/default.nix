{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pyrisco";
  version = "0.6.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "OnFreund";
    repo = "pyrisco";
    rev = "refs/tags/v${version}";
    hash = "sha256-+qnwJzf4nKio4IJo7NNA19B3tbOd+jhnGryiRMcdi6o=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pyrisco"
  ];

  meta = with lib; {
    description = "Python interface to Risco alarm systems through Risco Cloud";
    homepage = "https://github.com/OnFreund/pyrisco";
    changelog = "https://github.com/OnFreund/pyrisco/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
