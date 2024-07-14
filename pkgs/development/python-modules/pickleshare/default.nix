{
  lib,
  buildPythonPackage,
  fetchPypi,
  path,
}:

buildPythonPackage rec {
  version = "0.7.5";
  format = "setuptools";
  pname = "pickleshare";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-h2g9R5ZcHaZc2srzHIRB0SuARM3smspQDNePwsaDr8o=";
  };

  propagatedBuildInputs = [ path ];

  # No proper test suite
  doCheck = false;

  meta = with lib; {
    description = "Tiny 'shelve'-like database with concurrency support";
    homepage = "https://github.com/vivainio/pickleshare";
    license = licenses.mit;
  };
}
