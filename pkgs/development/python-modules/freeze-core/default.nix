{
  buildPythonPackage,
  distutils,
  fetchFromGitHub,
  filelock,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "freeze-core";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marcelotduarte";
    repo = "freeze-core";
    tag = version;
    hash = "sha256-9uw47EwMl/I6/A76w0xrfexv9D0uKskow8zUmcdnnfE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=78.1.1,<=80.9.0" "setuptools>=78.1.1"
  '';

  build-system = [
    distutils
    setuptools
  ];

  dependencies = [
    filelock
  ];

  pythonImportsCheck = [ "freeze_core" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/marcelotduarte/freeze-core/releases/tag/${src.tag}";
    description = "Core dependency for cx_Freeze";
    homepage = "https://github.com/marcelotduarte/freeze-core";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
