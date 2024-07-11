{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyatag";
  version = "0.3.7.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MatsNl";
    repo = "pyatag";
    rev = "refs/tags/${version}";
    hash = "sha256-3h9mpopTbEULCx7rcEt/I/ZnUA0L/fJ7Y3L5h/6EuC4=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ aiohttp ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [
    "pyatag"
    "pyatag.discovery"
  ];

  # it would use the erroneous tag 3.5.1
  passthru.skipBulkUpdate = true;

  meta = with lib; {
    description = "Python module to talk to Atag One";
    homepage = "https://github.com/MatsNl/pyatag";
    changelog = "https://github.com/MatsNl/pyatag/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
