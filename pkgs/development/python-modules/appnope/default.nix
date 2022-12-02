{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "appnope";
  version = "0.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Ar2RxN6Gn7seHFCq/ECYgnp6VKsvOdncumyVR+2SDiQ=";
  };

  meta = {
    description = "Disable App Nap on macOS";
    homepage    = "https://pypi.python.org/pypi/appnope";
    platforms   = lib.platforms.darwin;
    license     = lib.licenses.bsd3;
  };
}
