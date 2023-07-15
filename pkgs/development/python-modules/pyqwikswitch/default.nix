{ lib
, buildPythonPackage
, fetchPypi
, attrs
, requests
, python
}:

buildPythonPackage rec {
  pname = "pyqwikswitch";
  version = "0.94";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IpyWz+3EMr0I+xULBJJhBgdnQHNPJIM1SqKFLpszhQc=";
  };

  propagatedBuildInputs = [
    attrs
    requests
  ];

  pythonImportsCheck = [
    "pyqwikswitch"
    "pyqwikswitch.threaded"
  ];

  doCheck = false; # no tests in sdist

  meta = with lib; {
    description = "QwikSwitch USB Modem API binding for Python";
    homepage = "https://github.com/kellerza/pyqwikswitch";
    license = licenses.mit;
    maintainers = teams.home-assistant.members;
  };
}
