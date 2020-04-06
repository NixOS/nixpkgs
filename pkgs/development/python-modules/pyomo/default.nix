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
  version = "5.6.1";
  disabled = isPy27; # unable to import pyutilib.th

  src = fetchPypi {
    pname = "Pyomo";
    inherit version;
    sha256 = "449be9a4c9b3caee7c89dbe5f0e4e5ad0eaeef8be110a860641cd249986e362c";
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
    homepage = http://pyomo.org;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
