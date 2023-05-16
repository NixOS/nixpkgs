{ lib
, fetchPypi
, buildPythonPackage
, setuptools-scm
, docutils
, pyparsing
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "amply";
<<<<<<< HEAD
  version = "0.1.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YUIRA8z44QZnFxFf55F2ENgx1VHGjTGhEIdqW2x4rqQ=";
=======
  version = "0.1.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rXF7SQtrcFWQn6oZXoKkQytwb4+VhUBQFy9Ckx5HhCY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [
    docutils
    pyparsing
  ];
  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "amply" ];

  meta = with lib; {
    homepage = "https://github.com/willu47/amply";
    description = ''
      Allows you to load and manipulate AMPL/GLPK data as Python data structures
    '';
    maintainers = with maintainers; [ ris ];
    license = licenses.epl10;
  };
}
