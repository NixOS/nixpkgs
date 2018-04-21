{ stdenv, buildPythonPackage, fetchPypi, nose, nibabel, numpy, scikitlearn
, scipy, matplotlib }:

buildPythonPackage rec {
  pname = "nilearn";
  version = "0.4.1";
  name = pname + "-" + version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c2ef16d357d24699abced07e89a50d465c8fbaa8537f1a9d4d5cb8a612926dbc";
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
