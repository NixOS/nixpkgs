{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "easydict";
  version = "1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f1ec91110737a62fe28d14970ffa7a7c7b441a32e35a6f3da6a6082ffb7f9432";
  };

  docheck = false; # No tests in archive

  meta = {
    homepage = https://github.com/makinacorpus/easydict;
    license = with stdenv.lib; licenses.lgpl3;
    description = "Access dict values as attributes (works recursively)";
  };
}
