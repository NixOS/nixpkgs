{
  lib,
  stdenv,
  buildPythonPackage,
  pythonAtLeast,
  fetchPypi,
  hatch,
  hatch-vcs,
  hatch-mypyc,
  ipython,
  numpy,
  pytestCheckHook,
  pytest-cov-stub,
  sybil,
  beartype,
  typing-extensions,
  rich,
}:

buildPythonPackage (finalAttrs: {
  pname = "plum-dispatch";
  version = "2.8.0";
  pyproject = true;

  src = fetchPypi {
    pname = "plum_dispatch";
    inherit (finalAttrs) version;
    hash = "sha256-RT/HvGfSo5SSyDSwDJTYFocdFItaCl0/SeK78jkeJhk=";
  };

  # https://github.com/beartype/plum/pull/225
  disabled = pythonAtLeast "3.14";

  build-system = [
    hatch
    hatch-vcs
    hatch-mypyc
  ];

  dependencies = [
    beartype
    typing-extensions
    rich
  ];

  nativeCheckInputs = [
    pytestCheckHook
    ipython
    numpy
    pytest-cov-stub
    sybil
  ];

  disabledTests = lib.optional stdenv.hostPlatform.isDarwin "test_methodlist_repr";

  pythonImportsCheck = [ "plum" ];

  meta = {
    homepage = "https://beartype.github.io/plum";
    changelog = "https://github.com/beartype/plum/releases/tag/v${finalAttrs.version}";
    description = "Multiple dispatch in Python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ulysseszhan ];
  };
})
