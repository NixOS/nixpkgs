{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "fitdecode";
  version = "0.10.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-G4XRMDyHZQwRN3pzInV+qhyvIpd2u9W1RVkd1oFRI+Q=";
  };

  doCheck = false;

  meta = {
    description = "A FIT file parsing and decoding library written in Python3";
    homepage = "https://github.com/polyvertex/fitdecode";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ antonmosich ];
  };
}
