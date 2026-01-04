{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  dataprep-ml,
  numpy,
  pandas,
  scikit-learn,
  type-infer,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mindsdb-evaluator";
  version = "0.0.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mindsdb";
    repo = "mindsdb_evaluator";
    tag = "v${version}";
    hash = "sha256-ZeJABMbyRdGrZGkWWXcjleOeDQBSicGR06hZAPUKvgI=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "dataprep-ml"
    "numpy"
    "scikit-learn"
  ];

  dependencies = [
    dataprep-ml
    numpy
    pandas
    scikit-learn
    type-infer
  ];

  pythonImportsCheck = [ "mindsdb_evaluator" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/mindsdb/mindsdb_evaluator/releases/tag/${src.tag}";
    description = "Model evaluation for Machine Learning pipelines";
    homepage = "https://github.com/mindsdb/mindsdb_evaluator";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mbalatsko ];
  };
}
