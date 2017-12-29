{ stdenv, buildPythonPackage, fetchPypi, nose, nibabel, numpy, scikitlearn
, scipy, matplotlib }:

buildPythonPackage rec {
  pname = "nilearn";
  version = "0.3.1";
  name = pname + "-" + version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kkarh5cdcd2czs0bf0s1g51qas84mfxfq0dzd7k5h5l0qr4zy06";
  };

  checkPhase = "nosetests --exclude with_expand_user nilearn/tests";

  buildInputs = [ nose ];

  propagatedBuildInputs = [
    matplotlib
    nibabel
    numpy
    scikitlearn
    scipy
  ];

  meta = with stdenv.lib; {
    homepage = http://nilearn.github.io;
    description = "A module for statistical learning on neuroimaging data";
    license = licenses.bsd3;
  };
}
