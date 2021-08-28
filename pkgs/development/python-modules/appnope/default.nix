{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "appnope";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dd83cd4b5b460958838f6eb3000c660b1f9caf2a5b1de4264e941512f603258a";
  };

  meta = {
    description = "Disable App Nap on macOS";
    homepage    = "https://pypi.python.org/pypi/appnope";
    platforms   = lib.platforms.darwin;
    license     = lib.licenses.bsd3;
  };
}
