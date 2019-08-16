{ lib
, buildPythonPackage
, fetchPypi
, numpy
, scipy
, nose
, fetchpatch
}:

buildPythonPackage rec {
  pname = "pykalman";
  version = "0.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f7v0y71wx514b1r65nr11d1c8cc5jg4p9vg073a896r41vz8sl1";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/everling/pykalman/commit/644c85c3fbd9f957f6fef862a77dfb672b20b46a.patch";
      sha256 = "052qq2lbz9fk7zq689chniv1c5j6rx9d6s6dy7sqw78bj5z0mkgd";
    })
  ];

  propagatedBuildInputs = [ numpy scipy ];
  checkInputs = [ nose ];

  meta = with lib; {
    description = "An implementation of the Kalman Filter, Kalman Smoother, and EM algorithm in Python";
    homepage = "https://pykalman.github.io/";
    license = licenses.bsd0;
  };
}
