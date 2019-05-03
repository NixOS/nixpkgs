{ lib
, buildPythonPackage
, pytest
, tornado
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pytest-tornado";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jv7jhq6ddhsmnz67vc76r4kwac9k5a142968zppyw9av6qalbl4";
  };

  # package has no tests
  doCheck = false;

  propagatedBuildInputs = [ pytest tornado ];

  meta = with lib; {
    description = "A py.test plugin providing fixtures and markers to simplify testing of asynchronous tornado applications.";
    homepage =  https://github.com/eugeniy/pytest-tornado;
    license = licenses.asl20;
    maintainers = with maintainers; [ ixxie ];
  };
}
