{ lib, buildPythonPackage, fetchPypi, cryptography, protobuf }:

buildPythonPackage rec {
  pname = "omemo-dr";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KoqMdyMdc5Sb3TdSeNTVomElK9ruUstiQayyUcIC02E=";
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
