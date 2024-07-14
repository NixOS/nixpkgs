{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "hsaudiotag3k";
  version = "1.1.3.post1";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-72DpIQ1HJ+gvAJWmhssHtnbQVZGPDFnFv6hZjaA+WdE=";
  };

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Pure Python library that lets one to read metadata from media files";
    homepage = "http://hg.hardcoded.net/hsaudiotag/";
    license = licenses.bsd3;
  };
}
