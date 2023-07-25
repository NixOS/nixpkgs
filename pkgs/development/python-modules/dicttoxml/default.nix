{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dicttoxml";
  version = "1.7.16";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bzbOZEiB21zYlAvum3yz8/a3sye6imfYPT4sqgU4v50=";
  };

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Converts a Python dictionary or other native data type into a valid XML string";
    homepage = "https://github.com/quandyfactory/dicttoxml";
    license = lib.licenses.gpl2;
  };
}
