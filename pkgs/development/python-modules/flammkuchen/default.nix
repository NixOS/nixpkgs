{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, numpy
, scipy
, tables
, pandas
, nose
, configparser
}:

buildPythonPackage rec {
  pname = "flammkuchen";
  version = "0.9.2";

  src = fetchFromGitHub {
     owner = "portugueslab";
     repo = "flammkuchen";
     rev = "v0.9.2";
     sha256 = "1sscj4fsp97g2bfpg08v0bbkp4jy16j3a17zmq4bv80q4lzdq1gd";
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
