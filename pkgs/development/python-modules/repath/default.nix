{ lib
<<<<<<< HEAD
, buildPythonPackage
, fetchPypi
, six
=======
, python3
, buildPythonPackage
, fetchPypi
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "repath";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gpITm6xqDkP9nXBgXU6NrrJdRmcuSE7TGiTHzgrvD7c=";
  };

<<<<<<< HEAD
  propagatedBuildInputs = [
=======
  propagatedBuildInputs = with python3.pkgs; [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    six
  ];

  pythonImportsCheck = [
    "repath"
  ];

  meta = {
    description = "A port of the node module path-to-regexp to Python";
    homepage = "https://github.com/nickcoutsos/python-repath";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.heyimnova ];
  };
}
