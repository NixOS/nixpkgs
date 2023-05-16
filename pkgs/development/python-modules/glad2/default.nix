{ lib
<<<<<<< HEAD
, buildPythonPackage
, fetchPypi
, jinja2
}:

buildPythonPackage rec {
=======
, python3
, fetchPypi
}:

python3.pkgs.buildPythonPackage rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "glad2";
  version = "2.0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7eFjn2nyugjx9JikCnB/NKYJ0k6y6g1sk2RomnmM99A=";
  };

<<<<<<< HEAD
  propagatedBuildInputs = [
    jinja2
  ];

  # no python tests
  doCheck = false;

=======
  propagatedBuildInputs = with python3.pkgs; [
    jinja2
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [ "glad" ];

  meta = with lib; {
    description = "Multi-Language GL/GLES/EGL/GLX/WGL Loader-Generator based on the official specifications";
<<<<<<< HEAD
    homepage = "https://github.com/Dav1dde/glad";
=======
    homepage = "https://pypi.org/project/glad2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}
