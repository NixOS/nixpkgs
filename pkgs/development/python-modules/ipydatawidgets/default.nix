{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pytest
, pytestcov
, nbval
, ipywidgets
, numpy
, six
, traittypes
}:

buildPythonPackage rec {
  pname = "ipydatawidgets";
  version = "4.0.1";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h7cppy959q6x5rvkdjhzxhqh57s37i2xsish5rfavcqbp2xgk4g";
  };

  propagatedBuildInputs = [
    ipywidgets
    numpy
    six
    traittypes
  ];

  checkInputs = [ pytest pytestcov nbval ];

  checkPhase = "pytest ipydatawidgets/tests";

  meta = {
    description = "Widgets to help facilitate reuse of large datasets across different widgets";
    homepage = "https://github.com/vidartf/ipydatawidgets";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
