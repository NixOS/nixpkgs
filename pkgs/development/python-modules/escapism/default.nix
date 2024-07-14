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
    hash = "sha256-cyVr37TyIjDwQo/G7+zuYc3E+tUxtvmLhJy5yAcR5Ow=";
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
