<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchPypi
, packaging
, setuptools
, sip
, wheel
}:

buildPythonPackage rec {
  pname = "pyqt-builder";
  version = "1.15.2";
  format = "pyproject";
=======
{ lib, fetchPypi, buildPythonPackage, packaging, sip }:

buildPythonPackage rec {
  pname = "pyqt-builder";
  version = "1.14.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    pname = "PyQt-builder";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-dGz+g8A+v/RFjUeKHAZxR5Dvk+RY7NWii8KDe6yI63Q=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

=======
    hash = "sha256-g7w+MAr/i0FAWAS2qcKRM4mrWcSK2fDLhYSm73O8pQI=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [ packaging sip ];

  pythonImportsCheck = [ "pyqtbuild" ];

  # There aren't tests
  doCheck = false;

  meta = with lib; {
    description = "PEP 517 compliant build system for PyQt";
    homepage = "https://pypi.org/project/PyQt-builder/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nrdxp ];
  };
}
