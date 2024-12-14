{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pyppmd";
  version = "1.1.0";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HTjOLkt+uEtTvIpSOAuU9mumw5MouIALMMK1vzFpOXM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonImportsCheck = [ "pyppmd" ];

  meta = with lib; {
    homepage = "https://codeberg.org/miurahr/pyppmd";
    description = "PPMd compression/decompression library";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ PopeRigby ];
  };

}
