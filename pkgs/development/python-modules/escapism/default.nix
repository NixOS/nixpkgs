{ pkgs
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "escapism";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5f1cc1fa04a95f5b85b3da194750f8a71846d493ea332f62e8798949f10c9b86";
  };

  # No tests distributed
  doCheck = false;

  meta = with pkgs.lib; {
    description = "Simple, generic API for escaping strings";
    homepage = "https://github.com/minrk/escapism";
    license = licenses.mit;
    maintainers = with maintainers; [ bzizou ];
  };
}
