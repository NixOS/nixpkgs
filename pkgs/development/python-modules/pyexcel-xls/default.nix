{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyexcel-io,
  xlrd,
  xlwt,
  nose,
  pyexcel,
  mock,
}:

buildPythonPackage rec {
  pname = "pyexcel-xls";
  version = "0.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XsYG74Znqvuww/vYJCp8I78XXufBCwj3B5m4T7LbhMs=";
  };

  propagatedBuildInputs = [
    pyexcel-io
    xlrd
    xlwt
  ];

  nativeCheckInputs = [
    nose
    pyexcel
    mock
  ];

  postPatch = ''
    substituteInPlace setup.py --replace "xlrd<2" "xlrd<3"
  '';

  checkPhase = "nosetests --exclude test_issue_151";

  meta = {
    description = "Wrapper library to read, manipulate and write data in xls using xlrd and xlwt";
    homepage = "http://docs.pyexcel.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
  };
}
