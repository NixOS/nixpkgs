{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-scm,

  # dependencies
  dvc,
  dvc-render,
  dvc-studio-client,
  funcy,
  gto,
  psutil,
  pynvml,
  ruamel-yaml,
  scmrepo,

  # optional-dependencies
  # all
  jsonargparse,
  lightgbm,
  lightning,
  matplotlib,
  mmcv,
  numpy,
  optuna,
  pandas,
  pillow,
  scikit-learn,
  tensorflow,
  torch,
  transformers,
  xgboost,
  # huggingface
  datasets,
  # fastai
  fastai,
}:

buildPythonPackage rec {
  pname = "dvclive";
  version = "3.49.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "dvclive";
    tag = version;
    hash = "sha256-jjYglvXPtwPJEp2Qo309QeRLYooUmsDhO1Dc1S3OjQg=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    dvc
    dvc-render
    dvc-studio-client
    funcy
    gto
    psutil
    pynvml
    ruamel-yaml
    scmrepo
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
    ]
    ++ jsonargparse.optional-dependencies.signatures;
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
    ]
    ++ jsonargparse.optional-dependencies.signatures;
    optuna = [ optuna ];
  };

  # Circular dependency with dvc
  doCheck = false;

  pythonImportsCheck = [ "dvclive" ];

  meta = {
    description = "Library for logging machine learning metrics and other metadata in simple file formats";
    homepage = "https://github.com/iterative/dvclive";
    changelog = "https://github.com/iterative/dvclive/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
