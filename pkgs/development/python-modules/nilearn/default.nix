{ stdenv, buildPythonPackage, fetchPypi, nose, nibabel, numpy, scikitlearn
, scipy, matplotlib }:

buildPythonPackage rec {
  pname = "nilearn";
  version = "0.4.2";
  name = pname + "-" + version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "5049363eb6da2e7c35589477dfc79bf69929ca66de2d7ed2e9dc07acf78636f4";
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
