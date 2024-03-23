{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "crcelk";
  version = "1.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Dl+WPXDRMxjGf0UFqujDkAWp9qbUC9kmneMituJaIqc=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "crcelk" ];

  meta = with lib; {
    description = "CrcElk is an updated fork of the CrcMoose module for recent versions of Python. It provides a pure Python implementation of the CRC algorithm and allows for variants to easily be defined by providing their parameters such as width, starting polynomial, etc. Python versions 2.6+ and 3.1+ are supported";
    homepage = "https://pypi.org/project/crcelk/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
