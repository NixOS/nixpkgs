{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "hsluv";
  version = "5.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hsluv";
    repo = "hsluv-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M2oELRuDwsFgmywtTLiTaL86ANh4gn9W7hwjDlgiMRo=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hsluv" ];

  meta = {
    description = "Python implementation of HSLuv";
    homepage = "https://github.com/hsluv/hsluv-python";
    changelog = "https://github.com/hsluv/hsluv-python/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
