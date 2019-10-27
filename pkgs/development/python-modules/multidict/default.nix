{ lib
, fetchPypi
, buildPythonPackage
, pytest, pytestrunner, pytestcov
, isPy3k
, isPy38
}:

buildPythonPackage rec {
  pname = "multidict";
  version = "4.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "024b8129695a952ebd93373e45b5d341dbb87c17ce49637b34000093f243dd4f";
  };

  checkInputs = [ pytest pytestrunner pytestcov ];

  disabled = !isPy3k;
  # pickle files needed for 3.8 https://github.com/aio-libs/multidict/pull/363
  doCheck = !isPy38;

  meta = with lib; {
    description = "Multidict implementation";
    homepage = https://github.com/aio-libs/multidict/;
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
