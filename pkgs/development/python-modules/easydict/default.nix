{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "easydict";
  version = "1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xpnwjdw4x5kficjgcajqcal6bxcb0ax8l6hdkww9fp6lrh28x8v";
  };

  meta = {
    homepage = https://github.com/makinacorpus/easydict;
    license = with stdenv.lib; licenses.lgpl;
    description = "Access dict values as attributes (works recursively)";
  };
}
