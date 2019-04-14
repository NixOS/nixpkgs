{ buildPythonPackage
, fetchPypi
, osqp
, ecos
, scs
, multiprocess
, fastcache
, six
, numpy
, scipy
, nose
, lib
}:

buildPythonPackage rec {
  pname = "cvxpy";
  version = "1.0.21";

  propagatedBuildInputs = [
    osqp ecos scs multiprocess fastcache six numpy scipy
  ];

  checkInputs = [ nose ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "11hdrgdcb7idncrbr00rmrxhi7f8sjm134x4wgqkkxwppklk36xv";
  };

  # Tests not discovered correctly on python3 unless nosetests invoked
  # explicitly.
  checkPhase = "nosetests -v";

  meta = {
    description = "A Python-embedded modeling language for convex optimization problems";
    homepage = https://www.cvxpy.org;
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.teh ];
  };
}
