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
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5053de7804676aba62783dbb0f23a2b3d74e35e5bfa238b88b7cbf148a38b69d";
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
    homepage = "https://github.com/pydata/patsy";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ilya-kolpakov ];
  };
}

