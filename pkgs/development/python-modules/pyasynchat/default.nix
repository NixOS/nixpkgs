{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyasyncore,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyasynchat";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonrob";
    repo = "pyasynchat";
    rev = "v${version}";
    hash = "sha256-Cep8tsapLjhPbVhMrC1ZUgd4jZZLOliL4yF0OX2KrYs=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pyasyncore
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck =
    if (pythonOlder "3.11") then
      ''
        substituteInPlace tests/test_asynchat.py \
          --replace-fail "asynchat = warnings_helper.import_deprecated('asynchat')" 'import asynchat' \
          --replace-fail "asyncore = warnings_helper.import_deprecated('asyncore')" 'import asyncore' \
          --replace-fail 'support.requires_working_socket(module=True)' ""
      ''
    else
      null;

  pythonImportsCheck = [
    "asynchat"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Make asynchat available for Python 3.12 onwards";
    homepage = "https://github.com/simonrob/pyasynchat";
    license = lib.licenses.psfl;
    maintainers = [ ];
  };
}
