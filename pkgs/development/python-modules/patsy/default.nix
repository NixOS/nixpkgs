{ lib
, fetchPypi
, buildPythonPackage
, nose
, six
, numpy
, scipy # optional, allows spline-related features (see patsy's docs)
, parameterized
}:

buildPythonPackage rec {
  pname = "patsy";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "149rbrdzwns0ay88caf1zsm1r53v1q5np1mrb36na50y432cw5gi";
  };

  checkInputs = [ nose parameterized ];
  checkPhase = "nosetests -v";

  propagatedBuildInputs = [
    six
    numpy
    scipy
  ];

  meta = {
    description = "A Python package for describing statistical models";
    homepage = https://github.com/pydata/patsy;
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ilya-kolpakov ];
  };
}

