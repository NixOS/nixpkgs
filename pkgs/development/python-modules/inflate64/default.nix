{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "inflate64";
  version = "1.0.0";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MniCe4A88Aah3yUfPhM3TH0m23eeWjMynMEXibgEvC0=";
  };
  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonImportsCheck = [ "inflate64" ];

  meta = {
    homepage = "https://codeberg.org/miurahr/inflate64";
    description = "Compress and decompress with Enhanced Deflate compression algorithm";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ PopeRigby ];
  };

}
