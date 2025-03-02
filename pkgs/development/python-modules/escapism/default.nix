{
  pkgs,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "escapism";
  version = "1.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "73256bdfb4f22230f0428fc6efecee61cdc4fad531b6f98b849cb9c80711e4ec";
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
