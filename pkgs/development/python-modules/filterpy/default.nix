{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  scipy,
  matplotlib,
  pytestCheckHook,
  stdenv, # for meta.broken
}:

buildPythonPackage (finalAttrs: {
  pname = "filterpy";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rlabbe";
    repo = "filterpy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IGK0luLLfISxCaOQAy04nLWAf+ZlVllaPoMuepL/Gk8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
    matplotlib
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/rlabbe/filterpy/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/rlabbe/filterpy";
    description = "Kalman filtering and optimal estimation library";
    license = lib.licenses.mit;
    maintainers = [ ];
    # last successful hydra build on darwin was in 2025
    broken = stdenv.hostPlatform.isDarwin;
  };
})
