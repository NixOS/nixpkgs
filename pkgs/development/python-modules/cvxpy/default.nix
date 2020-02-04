{ lib
, buildPythonPackage
, fetchPypi
, ecos-python
, multiprocess
, nose
, numpy
, osqp-python
, scipy
, scs-python
, six
}:

buildPythonPackage rec {
  pname = "cvxpy";
  version = "1.0.25";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "8535529ddb807067b0d59661dce1d9a6ddb2a218398a38ea7772328ad8a6ea13";
  };

  propagatedBuildInputs = [ ecos-python numpy multiprocess osqp-python scipy scs-python six ];

  checkInputs = [ nose ];

  checkPhase = ''
    nosetests cvxpy 
  '';
 
  meta = with lib; {
    description = "Embedded modeling language for convex optimization problems";
    homepage = "https://github.com/cvxgrp/cvxpy";
    license = licenses.asl20;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
