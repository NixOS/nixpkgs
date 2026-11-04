{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  pytz,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyrfc3339";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kurtraschke";
    repo = "pyRFC3339";
    tag = "v${version}";
    hash = "sha256-LW8LA8ezhTG10nVmYl2gDawQZLzX9sUlqcF7QqGxw8c=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

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
