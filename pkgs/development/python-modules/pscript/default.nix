{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  nodejs,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pscript";
  version = "0.7.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "flexxui";
    repo = "pscript";
    tag = "v${version}";
    hash = "sha256-AhVI+7FiWyH+DfAXnau4aAHJAJtsWEpmnU90ey2z35o=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    nodejs
  ];

  preCheck = ''
    # do not execute legacy tests
    rm -rf pscript_legacy
  '';

  pythonImportsCheck = [ "pscript" ];

  disabledTests = [
    # https://github.com/flexxui/pscript/issues/69
    "test_async_and_await"
  ];

  meta = with lib; {
    description = "Python to JavaScript compiler";
    homepage = "https://pscript.readthedocs.io";
    changelog = "https://github.com/flexxui/pscript/blob/v${version}/docs/releasenotes.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
