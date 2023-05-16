{ lib
, buildPythonPackage
, fetchPypi
, ruamel-base
, ruamel-yaml-clib
, isPyPy
}:

buildPythonPackage rec {
  pname = "ruamel-yaml";
<<<<<<< HEAD
  version = "0.17.32";
=======
  version = "0.17.21";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    pname = "ruamel.yaml";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-7JOQY3YZFOFFQpcqXLptM8I7CFmrY0L2HPBwz8YA78I=";
=======
    hash = "sha256-i3zml6LyEnUqNcGsQURx3BbEJMlXO+SSa1b/P10jt68=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Tests use relative paths
  doCheck = false;

  propagatedBuildInputs = [ ruamel-base ]
    ++ lib.optional (!isPyPy) ruamel-yaml-clib;

  pythonImportsCheck = [ "ruamel.yaml" ];

  meta = with lib; {
    description = "YAML parser/emitter that supports roundtrip preservation of comments, seq/map flow style, and map key order";
    homepage = "https://sourceforge.net/projects/ruamel-yaml/";
<<<<<<< HEAD
    changelog = "https://sourceforge.net/p/ruamel-yaml/code/ci/default/tree/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
