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
  version = "4.2.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d0e4b58b59b508165e8562b8f5d1dbfcd739855847ec0477bd9185a5e9b7c5bc";
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
