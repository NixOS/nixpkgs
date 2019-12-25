{ lib, pkgs, buildPythonPackage, fetchPypi, isPy27
, numpy
, scipy
, tables
, pandas
, nose
, configparser
}:

buildPythonPackage rec {
  pname = "flammkuchen";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e9aab9b229ace70d879b85618a9ce0e88dd6ce35d4dbcdfd60c6b61c33a1b4fb";
  };

  checkInputs = [
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
