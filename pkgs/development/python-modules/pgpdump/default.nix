{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pgpdump";
  version = "1.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HEcAhXv3unNbCM/kEBqjpPX9g5ZXryScF7JpfCCClmg=";
  };

  # Disabling check because of: https://github.com/toofishes/python-pgpdump/issues/18
  doCheck = false;

  meta = with lib; {
    description = "Python library for parsing PGP packets";
    homepage = "https://github.com/toofishes/python-pgpdump";
    license = licenses.bsd3;
  };
}
