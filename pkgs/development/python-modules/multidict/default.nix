{ lib
, fetchPypi
, buildPythonPackage
, pytest, pytestrunner
, isPy3k
}:

buildPythonPackage rec {
  pname = "multidict";
  version = "4.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5ba766433c30d703f6b2c17eb0b6826c6f898e5f58d89373e235f07764952314";
  };

  checkInputs = [ pytest pytestrunner ];

  disabled = !isPy3k;

  meta = with lib; {
    description = "Multidict implementation";
    homepage = https://github.com/aio-libs/multidict/;
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
