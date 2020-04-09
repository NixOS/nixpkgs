{ lib
, buildPythonPackage
, fetchPypi
, h5py
, hdmf
, numpy
, pandas
, python-dateutil
}:

buildPythonPackage rec {
  pname = "pynwb";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ca7525dc0c569523c52d9b115a5009224103877630f30fd54a01811fdb24f58d";
  };

  propagatedBuildInputs = [
    h5py
    hdmf
    numpy
    pandas
    python-dateutil
  ];

  meta = with lib; {
    description = "Package for working with Neurodata stored in the NWB format";
    homepage = https://github.com/NeurodataWithoutBorders/pynwb;
    license = licenses.bsd3;
    maintainers = [ maintainers.tbenst ];
  };
}