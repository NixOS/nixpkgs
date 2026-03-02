{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  arviz-base,
  arviz-plots,
  arviz-stats,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "arviz";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "arviz-devs";
    repo = "arviz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mmmW0r2OXXKcwpOPeaSibWLtBGiGEGgst0i4I0OZTOk=";
  };

  build-system = [
    flit-core
  ];

  dependencies = [
    arviz-base
    arviz-plots
    arviz-stats
  ]
  ++ arviz-stats.optional-dependencies.xarray;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "arviz" ];

  meta = {
    description = "Library for exploratory analysis of Bayesian models";
    homepage = "https://arviz-devs.github.io/arviz/";
    changelog = "https://github.com/arviz-devs/arviz/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ omnipotententity ];
  };
})
