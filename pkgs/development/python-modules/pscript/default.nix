{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  nodejs,
}:

buildPythonPackage (finalAttrs: {
  pname = "pscript";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "flexxui";
    repo = "pscript";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pqjig3dFJ4zfpor6TT6fiBMS7lAtJE/bAYbzl46W/YY=";
  };

  postPatch = ''
    # https://github.com/flexxui/pscript/pull/77
    substituteInPlace pscript/commonast.py \
      --replace-fail "ast.Ellipsis" "ast.Constant"
  '';

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

  meta = {
    description = "Python to JavaScript compiler";
    homepage = "https://pscript.readthedocs.io";
    changelog = "https://github.com/flexxui/pscript/blob/${finalAttrs.src.tag}/docs/releasenotes.rst";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
})
