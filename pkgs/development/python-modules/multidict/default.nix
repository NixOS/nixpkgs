{ lib
, fetchPypi
, buildPythonPackage
, cython
, pytest, psutil, pytestrunner
, isPy3k
}:

buildPythonPackage rec {
  pname = "multidict";
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0liazqlyk2nmr82nhiw2z72j7bjqxaisifkj476msw140d4i4i7v";
  };

  buildInputs = [ cython ];
  checkInputs = [ pytest psutil pytestrunner ];

  disabled = !isPy3k;

  meta = with lib; {
    description = "Multidict implementation";
    homepage = https://github.com/aio-libs/multidict/;
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
