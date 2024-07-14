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

  meta = with lib; {
    description = "Python module to convert numbers from base 10 integers to base X strings and back again";
    homepage = "https://github.com/semente/python-baseconv";
    license = licenses.psfl;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
