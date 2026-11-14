{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  dill,
  multiprocess,

  # optional-dependencies
  joblib,
  mpi4py,

  # tests
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "schwimmbad";
  version = "0.4.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "adrn";
    repo = "schwimmbad";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q4TaxdzEkQzIVmUcdcv3XX6PlmP/KfxxbyjjQm68ZOI=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    dill
    multiprocess
  ];

  optional-dependencies = {
    all = [
      joblib
      mpi4py
    ];
  };

  pythonImportsCheck = [ "schwimmbad" ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.all;

  meta = {
    description = "Common interface for parallel processing pools";
    homepage = "https://github.com/adrn/schwimmbad";
    changelog = "https://github.com/adrn/schwimmbad/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
