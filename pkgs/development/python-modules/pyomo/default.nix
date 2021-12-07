{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pyutilib
, appdirs
, ply
, six
, nose
}:

buildPythonPackage rec {
  pname = "pyomo";
  version = "5.7.3";
  disabled = isPy27; # unable to import pyutilib.th

  src = fetchPypi {
    pname = "Pyomo";
    inherit version;
    sha256 = "2c4697107477a1b9cc9dad534d8f9c2dc6ee397c47ad44113e257732b83cfc8f";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [
    pyutilib
    appdirs
    ply
    six
  ];

  checkPhase = ''
    rm pyomo/bilevel/tests/test_blp.py \
       pyomo/version/tests/test_installer.py
    nosetests
  '';

  meta = with lib; {
    description = "Pyomo: Python Optimization Modeling Objects";
    homepage = "http://pyomo.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
