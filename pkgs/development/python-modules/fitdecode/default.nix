{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "fitdecode";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "polyvertex";
    repo = "fitdecode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3NoJHPql5mVQ+h2InM8tp7LIuR2znJyaawISarr688Q=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fitdecode" ];

  meta = {
    changelog = "https://github.com/polyvertex/fitdecode/blob/${finalAttrs.src.tag}/HISTORY.rst";
    description = "FIT file parsing and decoding library written in Python3";
    license = lib.licenses.mit;
    homepage = "https://github.com/polyvertex/fitdecode";
    maintainers = with lib.maintainers; [ tebriel ];
  };
})
