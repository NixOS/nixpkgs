{ lib
, fetchFromGitHub
, buildPythonPackage
<<<<<<< HEAD
, packaging
, setuptools
, pkgconfig
, freetype
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytest
, python
, pillow
, numpy
}:

buildPythonPackage rec {
  pname = "aggdraw";
<<<<<<< HEAD
  version = "1.3.16";
  format = "pyproject";
=======
  version = "1.3.15";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pytroll";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-2yajhuRyQ7BqghbSgPClW3inpw4TW2DhgQbomcRFx94=";
  };

  nativeBuildInputs = [
    packaging
    setuptools
    pkgconfig
  ];

  buildInputs = [
    freetype
  ];

=======
    hash = "sha256-w3HlnsHYB0R+HZOXtzygC2RST3gllPI7SYtwSCVXhTU=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    numpy
    pillow
    pytest
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} selftest.py
    runHook postCheck
  '';

  pythonImportsCheck = [ "aggdraw" ];

  meta = with lib; {
    description = "High quality drawing interface for PIL";
    homepage = "https://github.com/pytroll/aggdraw";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
