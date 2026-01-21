{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  pytz,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyrfc3339";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kurtraschke";
    repo = "pyRFC3339";
    tag = "v${version}";
    hash = "sha256-pNtv60ecJ7kceS+dDMuKVCQGARf0SbNVBLqqTIzHDj0=";
  };

  build-system = [ setuptools ];

  dependencies = [ pytz ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyrfc3339"
  ];

  meta = {
    changelog = "https://github.com/kurtraschke/pyRFC3339/blob/${src.tag}/CHANGES.rst";
    description = "Generate and parse RFC 3339 timestamps";
    homepage = "https://github.com/kurtraschke/pyRFC3339";
    license = lib.licenses.mit;
  };
}
