{ lib
, fetchPypi
, buildPythonPackage
, pytest, pytestrunner, pytestcov
, isPy3k
, isPy38
}:

buildPythonPackage rec {
  pname = "multidict";
  version = "4.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d7d428488c67b09b26928950a395e41cc72bb9c3d5abfe9f0521940ee4f796d4";
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
