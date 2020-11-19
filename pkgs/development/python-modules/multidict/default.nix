{ lib
, fetchPypi
, buildPythonPackage
, pytest, pytestrunner, pytestcov
, isPy3k
, isPy38
}:

buildPythonPackage rec {
  pname = "multidict";
  version = "4.7.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fbb77a75e529021e7c4a8d4e823d88ef4d23674a202be4f5addffc72cbb91430";
  };

  checkInputs = [ pytest pytestrunner pytestcov ];

  disabled = !isPy3k;
  # pickle files needed for 3.8 https://github.com/aio-libs/multidict/pull/363
  doCheck = !isPy38;

  meta = with lib; {
    description = "Multidict implementation";
    homepage = "https://github.com/aio-libs/multidict/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
