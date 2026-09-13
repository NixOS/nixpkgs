{
  lib,
  stdenv,
  alembic,
  boto3,
  botorch,
  bottle,
  buildPythonPackage,
  cmaes,
  colorlog,
  fetchFromGitHub,
  httpx,
  moto,
  numpy,
  openai,
  optuna,
  packaging,
  plotly,
  pytestCheckHook,
  respx,
  scikit-learn,
  scipy,
  setuptools,
  streamlit,
  tqdm,
  fetchPnpmDeps,
  nodejs,
  pnpm_11,
  pnpmConfigHook,
}:
let
  pnpm = pnpm_11;
in
buildPythonPackage (finalAttrs: {
  pname = "optuna-dashboard";
  version = "0.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "optuna";
    repo = "optuna-dashboard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NRUR35RiGR+c53s8Un7KE2aeCWhTk6oXoK3ckyE175g=";
  };

  dependencies = [
    alembic
    bottle
    cmaes
    colorlog
    numpy
    optuna
    packaging
    scikit-learn
    scipy
    tqdm
  ];

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
  ];

  pnpmWorkspaces = [
    "@optuna/types"
    "@optuna/storage"
    "@optuna/react"
    "@optuna/optuna-dashboard"
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-tMqF4tyk6Tyb5eN777B4dAwJSmzkVKfkYY43WELR24g=";
  };

  preBuild = ''
    pnpm --filter=@optuna/types build

    pnpm --filter=@optuna/storage build

    pnpm --filter=@optuna/react build

    pnpm --filter=@optuna/optuna-dashboard build:prd
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    boto3
    botorch
    httpx
    moto
    openai
    plotly
    respx
    streamlit
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # AttributeError: module 'numpy' has no attribute 'float128' ==> not available on 64-bit Darwin
    "test_infer_sortable"
    "test_serialize_numpy_floating"
  ];

  # Disable tests that use playwright (needs network)
  disabledTestPaths = [
    "e2e_tests/test_dashboard/test_usecases/test_preferential_optimization.py"
    "e2e_tests/test_dashboard/test_usecases/test_study_history.py"
    "e2e_tests/test_dashboard/visual_regression_test.py"
    "e2e_tests/test_standalone/test_study_list.py"
  ];

  pythonImportsCheck = [ "optuna_dashboard" ];

  # Temporarily disable tests as they hang due to a torch bug on darwin
  # Will revert in https://github.com/NixOS/nixpkgs/pull/424873
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    description = "Real-time Web Dashboard for Optuna";
    homepage = "https://github.com/optuna/optuna-dashboard";
    changelog = "https://github.com/optuna/optuna-dashboard/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
    mainProgram = "optuna-dashboard";
  };
})
