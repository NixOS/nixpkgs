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
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fw888zd2s7f5zxm9f98ss93qhwv0sqnbdy21ipj33ccqgakhpz0";
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

