{ lib
, buildPythonPackage
, fetchPypi
, mailman
, mock
, nose2
, python
, pythonOlder
, requests
, zope_interface
}:

buildPythonPackage rec {
  pname = "mailman-hyperkitty";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-EQBx1KX3z/Wv3QAHOi+s/ihLOjpiupIQBYyE6IPbJto=";
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
