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
    sha256 = "d9e5eb4708ebf13353c4cfce798ad47890a8bcc5fbae04630223d15d79f55e96";
  };

  meta = with lib; {
    description = "Small INI library for Python";
    homepage = "https://github.com/mitsuhiko/python-inifile";
    license = licenses.bsd0;
    maintainers = with maintainers; [ ];
  };
}
