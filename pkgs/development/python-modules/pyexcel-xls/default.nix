{ lib
, buildPythonPackage
, fetchPypi
, pyexcel-io
, xlrd
, xlwt
, nose
, pyexcel
, mock
}:

buildPythonPackage rec {
  pname = "pyexcel-xls";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "64bac180274c52efe970c664d3e8bb12402c9d10e0734d9fe87655646a876c45";
  };

  propagatedBuildInputs = [
    pyexcel-io
    xlrd
    xlwt
  ];

  checkInputs = [
    nose
    pyexcel
    mock
  ];

  checkPhase = "nosetests";

  meta = {
    description = "A wrapper library to read, manipulate and write data in xls using xlrd and xlwt";
    homepage = "http://docs.pyexcel.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jtojnar ];
  };
}
