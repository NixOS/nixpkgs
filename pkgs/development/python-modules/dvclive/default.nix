{
  lib,
  buildPythonPackage,
  datasets,
  dvc,
  dvc-render,
  dvc-studio-client,
  fastai,
  fetchFromGitHub,
  funcy,
  gto,
  jsonargparse,
  lightgbm,
  lightning,
  matplotlib,
  mmcv,
  numpy,
  optuna,
  pandas,
  pillow,
  psutil,
  pynvml,
  pythonOlder,
  ruamel-yaml,
  scikit-learn,
  scmrepo,
  setuptools-scm,
  tensorflow,
  torch,
  transformers,
  xgboost,
}:

buildPythonPackage rec {
  pname = "dvclive";
  version = "3.48.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "dvclive";
    tag = version;
    hash = "sha256-fLlP3kWmThQVVPEOd9KWitBIye/fhd/+zcHoVTF/pV8=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    dvc
    dvc-render
    dvc-studio-client
    funcy
    gto
    ruamel-yaml
    scmrepo
    psutil
    pynvml
  ];

  optional-dependencies = {
    all = [
      jsonargparse
      lightgbm
      lightning
      matplotlib
      mmcv
      numpy
      optuna
      pandas
      pillow
      scikit-learn
      tensorflow
      torch
      transformers
      xgboost
    ] ++ jsonargparse.optional-dependencies.signatures;
    image = [
      numpy
      pillow
    ];
    sklearn = [ scikit-learn ];
    plots = [
      pandas
      scikit-learn
      numpy
    ];
    markdown = [ matplotlib ];
    mmcv = [ mmcv ];
    tf = [ tensorflow ];
    xgb = [ xgboost ];
    lgbm = [ lightgbm ];
    huggingface = [
      datasets
      transformers
    ];
    # catalyst = [
    #   catalyst
    # ];
    fastai = [ fastai ];
    lightning = [
      lightning
      torch
      jsonargparse
    ] ++ jsonargparse.optional-dependencies.signatures;
    optuna = [ optuna ];
  };

  # Circular dependency with dvc
  doCheck = false;

  pythonImportsCheck = [ "dvclive" ];

  meta = with lib; {
    description = "Library for logging machine learning metrics and other metadata in simple file formats";
    homepage = "https://github.com/iterative/dvclive";
    changelog = "https://github.com/iterative/dvclive/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
