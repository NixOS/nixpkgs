{ lib, buildPythonPackage, fetchPypi, cryptography, protobuf }:

buildPythonPackage rec {
  pname = "omemo-dr";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sP5QI+lHoXt0D7ftSqJGEg1vIdgZtYEulN/JVwUgvmE=";
  };

  propagatedBuildInputs = [
    cryptography
    protobuf
  ];

  meta = {
    description = "OMEMO Double Ratchet";
    license = lib.licenses.lgpl3;
    homepage = "https://dev.gajim.org/gajim/omemo-dr/";
  };
}
