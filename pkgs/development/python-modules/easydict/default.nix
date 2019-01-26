{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "easydict";
  version = "1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3f3f0dab07c299f0f4df032db1f388d985bb57fa4c5be30acd25c5f9a516883b";
  };

  docheck = false; # No tests in archive

  meta = {
    homepage = https://github.com/makinacorpus/easydict;
    license = with stdenv.lib; licenses.lgpl3;
    description = "Access dict values as attributes (works recursively)";
  };
}
