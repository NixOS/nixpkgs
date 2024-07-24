{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "easydict";
  version = "1.13";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sRNd7bxByAEOK8H3fsl0TH+qQrzhoch0FnkUSdbId4A=";
  };

  doCheck = false; # No tests in archive

  pythonImportsCheck = [ "easydict" ];

  meta = with lib; {
    homepage = "https://github.com/makinacorpus/easydict";
    license = licenses.lgpl3;
    description = "Access dict values as attributes (works recursively)";
  };
}
