{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,
  pyprojectVersionPatchHook,

  # dependencies
  niapy,
  nltk,
  numpy,
  pandas,
  plotly,
  scikit-learn,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "niaarm";
  # nixpkgs-update: no auto update
  version = "0.13.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "NiaARM";
    tag = finalAttrs.version;
    hash = "sha256-524rJ5b9e0U1rqu1iCGMA3Tgnn9bO4biCC1FMoGNqms=";
  };

  pythonRelaxDeps = [
    "numpy"
    "pandas"
    "plotly"
    "scikit-learn"
  ];

  build-system = [ poetry-core ];

  # Fix upstream version typo
  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  dependencies = [
    niapy
    nltk
    numpy
    pandas
    plotly
    scikit-learn
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    # Prevents 'Fatal Python error: Aborted' on darwin during checkPhase
    MPLBACKEND = "Agg";
  };

  disabledTests = [
    # Test requires extra nltk data dependency
    "test_text_mining"

    # AttributeError: 'Poly3DCollection' object has no attribute '_vec'
    "test_hill_slopes"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "niaarm" ];

  meta = {
    description = "Minimalistic framework for Numerical Association Rule Mining";
    mainProgram = "niaarm";
    homepage = "https://github.com/firefly-cpp/NiaARM";
    changelog = "https://github.com/firefly-cpp/NiaARM/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ firefly-cpp ];
  };
})
