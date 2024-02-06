{ lib
, bleak
, bleak-retry-connector
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pymicrobot";
  version = "0.0.10";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "PyMicroBot";
    inherit version;
    hash = "sha256-A7qfRl958x0vsr/sxvK50M7fGUBFhdGiA+tbHOdk8gE=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    bleak
    bleak-retry-connector
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "microbot"
  ];

  meta = with lib; {
    description = "Library to communicate with MicroBot";
    homepage = "https://github.com/spycle/pyMicroBot/";
    changelog = "https://github.com/spycle/pyMicroBot/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
