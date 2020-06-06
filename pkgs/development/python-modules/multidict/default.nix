{ lib
, fetchPypi
, buildPythonPackage
, pytest, pytestrunner, pytestcov
, isPy3k
, isPy38
}:

buildPythonPackage rec {
  pname = "multidict";
  version = "4.7.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aee283c49601fa4c13adc64c09c978838a7e812f85377ae130a24d7198c0331e";
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
