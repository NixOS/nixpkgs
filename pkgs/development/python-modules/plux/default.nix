{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  stevedore,
  wheel,
}:

buildPythonPackage rec {
  pname = "plux";
  version = "1.13.0";
  pyproject = true;

  # Tests are not available from PyPi
  src = fetchFromGitHub {
    owner = "localstack";
    repo = "plux";
    tag = "v${version}";
    hash = "sha256-daAFv5tIekWDq0iI/yolmuak0MMXXVCfAcbHcYY7Qd4=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [ stevedore ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests = [
    # Fails with pytest >= 9 which uses PEP 639 License-Expression metadata
    # instead of legacy License field. Upstream pins pytest==8.4.1 in CI.
    # https://github.com/localstack/plux/pull/46
    "test_resolve_distribution_information"
  ];

  pythonImportsCheck = [ "plugin.core" ];

  meta = {
    description = "Dynamic code loading framework for building pluggable Python distributions";
    homepage = "https://github.com/localstack/plux";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
