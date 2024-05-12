{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, poetry-core
, dataprep-ml
, numpy
, pandas
, scikit-learn
, type-infer
}:

buildPythonPackage rec {
  pname = "mindsdb-evaluator";
  version = "0.0.13";
  pyproject = true;

  disabled = pythonOlder "3.8";

  # using PyPI as git repository does not have release tags or branches
  src = fetchPypi {
    pname = "mindsdb_evaluator";
    inherit version;
    hash = "sha256-SW3GYe9ykbs6ZViScdAgwiBAP9ix4v1VbSm/kJK2jDA=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
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
