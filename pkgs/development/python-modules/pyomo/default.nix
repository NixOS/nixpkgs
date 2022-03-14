{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, pyutilib
, appdirs
, ply
, six
, nose
, glpk
}:

buildPythonPackage rec {
  pname = "pyomo";
  version = "6.3.0";
  disabled = isPy27; # unable to import pyutilib.th

  src = fetchFromGitHub {
    repo = "pyomo";
    owner = "pyomo";
    rev = version;
    sha256 = "sha256-xyjiB5fDRf5y9Av5Cr+8wtU4pHzMHsM45mcmJEOaTWs=";
  };

  checkInputs = [ nose glpk ];
  propagatedBuildInputs = [
    pyutilib
    appdirs
    ply
    six
  ];

  checkPhase = ''
    rm pyomo/bilevel/tests/test_blp.py \
       pyomo/version/tests/test_installer.py \
       pyomo/common/tests/test_download.py \
       pyomo/core/tests/examples/test_pyomo.py
    export HOME=$TMPDIR
    nosetests
  '';

  meta = with lib; {
    description = "Pyomo: Python Optimization Modeling Objects";
    homepage = "http://pyomo.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
