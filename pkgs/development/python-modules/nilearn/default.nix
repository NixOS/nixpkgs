{ stdenv, buildPythonPackage, fetchPypi, nose, nibabel, numpy, scikitlearn
, scipy, matplotlib }:

buildPythonPackage rec {
  pname = "nilearn";
  version = "0.4.0";
  name = pname + "-" + version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "bb692254bde35d7e1d3d1534d9b3117810b35a744724625f150fbbc64d519c02";
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
