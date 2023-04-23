{ lib, buildPythonPackage, fetchPypi, isPy27
, numpy
, scipy
, tables
, pandas
, nose
, configparser
}:

buildPythonPackage rec {
  pname = "flammkuchen";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KtMGQftoYVNNMtfYeYiaQyMLAySpf9YXLMxj+e/CV5I=";
  };

  nativeCheckInputs = [
    nose
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    tables
    pandas
  ] ++ lib.optionals isPy27 [ configparser ];

  meta = {
    homepage = "https://github.com/portugueslab/flammkuchen";
    description = "Flexible HDF5 saving/loading library forked from deepdish (University of Chicago) and maintained by the Portugues lab";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tbenst ];
  };
}
