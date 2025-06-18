{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  poetry-core,
  dataprep-ml,
  numpy,
  pandas,
  scikit-learn,
  type-infer,
}:

buildPythonPackage rec {
  pname = "mindsdb-evaluator";
  version = "0.0.16";
  pyproject = true;

  disabled = pythonOlder "3.8";

  # using PyPI as git repository does not have release tags or branches
  src = fetchPypi {
    pname = "mindsdb_evaluator";
    inherit version;
    hash = "sha256-92XGu6ob1AfOoqcB/hqDf+lSDAUjZ5SPju5FkpcbOHA=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "numpy"
  ];

  dependencies = [
    dataprep-ml
    numpy
    pandas
    scikit-learn
    type-infer
  ];

  pythonImportsCheck = [ "mindsdb_evaluator" ];

  meta = with lib; {
    description = "Model evaluation for Machine Learning pipelines";
    homepage = "https://pypi.org/project/mindsdb-evaluator/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
