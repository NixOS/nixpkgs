{ lib
, fetchPypi
, buildPythonPackage
, pytest, pytestrunner, pytestcov
, isPy3k
, isPy38
}:

buildPythonPackage rec {
  pname = "multidict";
  version = "4.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d4dafdcfbf0ac80fc5f00603f0ce43e487c654ae34a656e4749f175d9832b1b5";
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
