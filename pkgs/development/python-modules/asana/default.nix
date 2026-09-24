{
  lib,
  buildPythonPackage,
  certifi,
  fetchFromGitHub,
  pytestCheckHook,
  python-dateutil,
  python-dotenv,
  setuptools,
  six,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "asana";
  version = "5.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asana";
    repo = "python-asana";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Bfq3FKJoZE8edAAFVNYYrLJ8vp44QYboEVsCGsI5WMY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    certifi
    six
    python-dateutil
    python-dotenv
    urllib3
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "asana" ];

  disabledTestPaths = [
    # Tests require network access
    "build_tests/"
  ];

  meta = {
    description = "Python client library for Asana";
    homepage = "https://github.com/asana/python-asana";
    changelog = "https://github.com/Asana/python-asana/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
