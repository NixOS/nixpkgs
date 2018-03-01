{ lib
, buildPythonPackage
, pytest
, tornado
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pytest-tornado";
  version = "0.4.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b1r5im7qmbpmxhfvq13a6rp78sjjrrpysfnjkd9hggavgc75dr8";
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
