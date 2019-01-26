{ lib
, buildPythonPackage
, pytest
, tornado
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pytest-tornado";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "214fc59d06fb81696fce3028b56dff522168ac1cfc784cfc0077b7b1e425b4cd";
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
