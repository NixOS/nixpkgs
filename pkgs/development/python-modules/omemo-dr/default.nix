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

  meta = with lib; {
    description = "OMEMO Double Ratchet";
    homepage = "https://dev.gajim.org/gajim/omemo-dr/";
    changelog = "https://dev.gajim.org/gajim/omemo-dr/-/blob/v${version}/CHANGELOG.md";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ ];
  };
}
