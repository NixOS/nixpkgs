{ lib
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  version = "1.6";
  pname = "progress";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c9c86e98b5c03fa1fe11e3b67c1feda4788b8d0fe7336c2ff7d5644ccfba34cd";
  };

  checkPhase = ''
    ${python.interpreter} test_progress.py
  '';

  meta = with lib; {
    homepage = "https://github.com/verigak/progress/";
    description = "Easy to use progress bars";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = [ ];
=======
    maintainers = [ maintainers.costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
