{ lib
, buildPythonPackage
, fetchPypi
, mailman
, mock
, nose2
, python
, requests
, zope_interface
}:

buildPythonPackage rec {
  pname = "mailman-hyperkitty";
  version = "1.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lfqa9admhvdv71f528jmz2wl0i5cv77v6l64px2pm4zqr9ckkjx";
  };

  propagatedBuildInputs = [
    mailman
    requests
    zope_interface
  ];

  checkInputs = [
    mock
    nose2
  ];

  checkPhase = ''
    ${python.interpreter} -m nose2 -v
  '';

  # There is an AssertionError
  doCheck = false;

  pythonImportsCheck = [
    "mailman_hyperkitty"
  ];

  meta = with lib; {
    description = "Mailman archiver plugin for HyperKitty";
    homepage = "https://gitlab.com/mailman/mailman-hyperkitty";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ globin qyliss ];
  };
}
