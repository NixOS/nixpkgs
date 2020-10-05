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
  version = "4.1.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d9f94828c11e3b40350fb14a02e027f42670a7c372bcb30db18d552dcfab7c01";
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
