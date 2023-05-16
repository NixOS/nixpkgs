{ lib
<<<<<<< HEAD
, buildPythonPackage
, fetchPypi

# build-system
, poetry-core

# propagates
, typing-extensions
, repath
=======
, python3
, buildPythonPackage
, fetchPypi
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "flet-core";
<<<<<<< HEAD
  version = "0.7.4";
=======
  version = "0.6.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchPypi {
    pname = "flet_core";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-8WG7odYiGrew4GwD+MUuzQPmDn7V/GmocBproqsbCNw=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    repath
    typing-extensions
=======
    hash = "sha256-WMkm+47xhuYz1HsiPfF7YbOCg7Xlbj9oHI9nVtwAb/w=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    typing-extensions
    repath
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  doCheck = false;

  meta = {
    description = "The library is the foundation of Flet framework and is not intended to be used directly";
    homepage = "https://flet.dev/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.heyimnova ];
  };
}
