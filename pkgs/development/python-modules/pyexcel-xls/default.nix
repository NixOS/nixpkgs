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
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5ec606ef8667aafbb0c3fbd8242a7c23bf175ee7c10b08f70799b84fb2db84cb";
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
    description = "A wrapper library to read, manipulate and write data in xls using xlrd and xlwt";
    homepage = "http://docs.pyexcel.org/";
    license = lib.licenses.bsd3;
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ ];
=======
    maintainers = with lib.maintainers; [ jtojnar ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
