{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  taglib,
  cython,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytaglib";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "supermihi";
    repo = "pytaglib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-529U71Lvs6QufcG3yBeywyGc2ukYYfFHIf6TFjt+k3U=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "cython==3.2.4" "cython"
  '';

  build-system = [ setuptools ];

  buildInputs = [
    cython
    taglib
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "taglib" ];

  meta = {
    description = "Python bindings for the Taglib audio metadata library";
    homepage = "https://github.com/supermihi/pytaglib";
    changelog = "https://github.com/supermihi/pytaglib/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ mrkkrp ];
    mainProgram = "pyprinttags";
  };
})
