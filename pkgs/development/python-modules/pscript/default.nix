{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  nodejs,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pscript";
  version = "0.8.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "flexxui";
    repo = "pscript";
    tag = "v${version}";
    hash = "sha256-pqjig3dFJ4zfpor6TT6fiBMS7lAtJE/bAYbzl46W/YY=";
  };

  build-system = [ flit-core ];

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
    changelog = "https://github.com/flexxui/pscript/blob/${src.tag}/docs/releasenotes.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
