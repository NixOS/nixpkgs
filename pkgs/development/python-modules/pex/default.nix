{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pex";
<<<<<<< HEAD
  version = "2.1.145";
  format = "pyproject";
=======
  version = "2.1.135";
  format = "flit";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-1rrIxOjOdGz+Xxb6QrH6Zth/eF+zaBOGFf4I9P17nbI=";
=======
    hash = "sha256-h6nv91IkI+6+cLHS8CYwm9tddbjiOOWsdk1+17PutvU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    flit-core
  ];

  # A few more dependencies I don't want to handle right now...
  doCheck = false;

  pythonImportsCheck = [
    "pex"
  ];

  meta = with lib; {
    description = "Python library and tool for generating .pex (Python EXecutable) files";
    homepage = "https://github.com/pantsbuild/pex";
    changelog = "https://github.com/pantsbuild/pex/releases/tag/v${version}";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ copumpkin phaer ];
=======
    maintainers = with maintainers; [ copumpkin ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
