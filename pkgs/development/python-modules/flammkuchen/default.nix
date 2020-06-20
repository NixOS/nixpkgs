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
  version = "0.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f249fe5bf85f717d3836e0db6fa9443a8a43101ce07704715b42251c44fc968e";
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
