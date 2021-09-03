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
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2fbf66e8df88051eaaa9745be433903d18db819ddd3a987c992ead1d68b7feb5";
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

  postPatch = ''
    substituteInPlace setup.py --replace "xlrd<2" "xlrd<3"
  '';

  checkPhase = "nosetests --exclude test_issue_151";

  meta = {
    description = "A wrapper library to read, manipulate and write data in xls using xlrd and xlwt";
    homepage = "http://docs.pyexcel.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jtojnar ];
  };
}
