{ lib
, fetchPypi
, buildPythonPackage
, pytest, pytestrunner
, isPy3k
}:

buildPythonPackage rec {
  pname = "multidict";
  version = "4.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3c11e92c3dfc321014e22fb442bc9eb70e01af30d6ce442026b0c35723448c66";
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
