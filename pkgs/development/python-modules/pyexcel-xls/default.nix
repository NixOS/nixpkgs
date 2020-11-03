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
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c4cc1fb4ac5d1682a44d9a368a43ec2e089ad6fc46884648ccfad46863e3da0a";
  };

  requiredPythonModules = [
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
