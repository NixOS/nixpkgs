{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "durationpy";
  version = "0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "icholy";
    repo = "durationpy";
    rev = version;
    hash = "sha256-R/cZPnUUlosGHCOcqwRJ0GJlcB6Lu5a3e5h1CQ6fysA=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "test.py" ];

  pythonImportsCheck = [ "durationpy" ];

  meta = {
    description = "Module for converting between datetime.timedelta and Go's time.Duration strings";
    homepage = "https://github.com/icholy/durationpy";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
