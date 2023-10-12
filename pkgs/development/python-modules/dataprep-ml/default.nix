{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, poetry-core
, numpy
, pandas
, pydateinfer
, python-dateutil
, scipy
, type-infer
, dataclasses-json
, colorlog
, pydantic
, nltk-data
, symlinkJoin
}:
let
  testNltkData = symlinkJoin {
    name = "nltk-test-data";
    paths = [ nltk-data.punkt nltk-data.stopwords ];
  };
in
buildPythonPackage rec {
  pname = "dataprep-ml";
  version = "0.0.18";
  pyproject = true;

  disable = pythonOlder "3.8";

  # using PyPI as github repo does not contain tags or release branches
  src = fetchPypi {
    pname = "dataprep_ml";
    inherit version;
    hash = "sha256-nIqyRwv62j8x5Fy7ILMLWxw6yJmkkNRE1zyUlfvRYTI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    numpy
    pandas
    pydateinfer
    python-dateutil
    scipy
    type-infer
    dataclasses-json
    colorlog
    pydantic
  ];

  # PyPI tarball has no tests
  doCheck = false;

  # Package import requires NLTK data to be downloaded
  # It is the only way to set NLTK_DATA environment variable,
  # so that it is available in pythonImportsCheck
  env.NLTK_DATA = testNltkData;
  pythonImportsCheck = [
    "dataprep_ml"
    "dataprep_ml.cleaners"
    "dataprep_ml.helpers"
    "dataprep_ml.imputers"
    "dataprep_ml.insights"
    "dataprep_ml.recommenders"
    "dataprep_ml.splitters"
  ];

  meta = with lib; {
    description = "Data utilities for Machine Learning pipelines";
    homepage = "https://github.com/mindsdb/dataprep_ml";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
