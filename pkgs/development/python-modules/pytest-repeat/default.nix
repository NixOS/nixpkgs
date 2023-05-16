{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-repeat";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5cd3289745ab3156d43eb9c8e7f7d00a926f3ae5c9cf425bec649b2fe15bad5b";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytest
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Pytest plugin for repeating tests";
    homepage = "https://github.com/pytest-dev/pytest-repeat";
    license = licenses.mpl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
