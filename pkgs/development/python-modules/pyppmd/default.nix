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

  meta = {
    homepage = "https://codeberg.org/miurahr/pyppmd";
    description = "PPMd compression/decompression library";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ PopeRigby ];
  };

}
