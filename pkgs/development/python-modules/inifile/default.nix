{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "inifile";
  version = "0.4.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2eXrRwjr8TNTxM/OeYrUeJCovMX7rgRjAiPRXXn1XpY=";
  };

  meta = {
    description = "Small INI library for Python";
    homepage = "https://github.com/mitsuhiko/python-inifile";
    license = lib.licenses.bsd0;
    maintainers = [ ];
  };
}
