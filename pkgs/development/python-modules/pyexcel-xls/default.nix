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
  version = "0.5.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1Wyt6gpmBoRFaXbZgFJVTTu+KnivxfmpHIaR9iZghVU=";
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
