{ lib, buildPythonPackage, fetchPypi, unittestCheckHook }:

buildPythonPackage rec {
  pname = "pycparser";
  version = "2.21";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206";
  };

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "-s" "tests" ];

  meta = with lib; {
    description = "C parser in Python";
    homepage = "https://github.com/eliben/pycparser";
    license = licenses.bsd3;
    maintainers = with maintainers; [ domenkozar ];
  };
}
