{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "devialet";
  version = "1.4.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fwestenberg";
    repo = "devialet";
    rev = "refs/tags/v${version}";
    hash = "sha256-DVwf1zQXwPe8W2SzL9CnYE+gwLgPEnI+tQTfR+ijwF4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "devialet"
  ];

  meta = with lib; {
    description = "Library to interact with the Devialet API";
    homepage = "https://github.com/fwestenberg/devialet";
    changelog = "https://github.com/fwestenberg/devialet/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
