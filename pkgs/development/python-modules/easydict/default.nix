{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "easydict";
  version = "1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xpnwjdw4x5kficjgcajqcal6bxcb0ax8l6hdkww9fp6lrh28x8v";
  };

  docheck = false; # No tests in archive

  meta = {
    homepage = https://github.com/makinacorpus/easydict;
    license = with stdenv.lib; licenses.lgpl3;
    description = "Access dict values as attributes (works recursively)";
  };
}
