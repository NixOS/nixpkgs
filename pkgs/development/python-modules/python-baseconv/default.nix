{
  buildPythonPackage,
  fetchPypi,
  lib,
}:
buildPythonPackage rec {
  pname = "python-baseconv";
  version = "1.2.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BTn4vQRkATsFrWLgoWc/CskIbHa0Pr+fgzBTUnzZkxs=";
  };

  pythonImportsCheck = [ "baseconv" ];

  meta = {
    description = "Python module to convert numbers from base 10 integers to base X strings and back again";
    homepage = "https://github.com/semente/python-baseconv";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ rakesh4g ];
  };
}
