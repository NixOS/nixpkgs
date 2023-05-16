{ lib
, buildPythonPackage
, dbus-python
, fetchFromGitHub
, numpy
, openrazer-daemon
}:

let
  common = import ./common.nix { inherit lib fetchFromGitHub; };
in
buildPythonPackage (common // {
  pname = "openrazer";

<<<<<<< HEAD
  sourceRoot = "${common.src.name}/pylib";
=======
  sourceRoot = "source/pylib";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = [
    dbus-python
    numpy
    openrazer-daemon
  ];

  # no tests run
  doCheck = false;

  meta = common.meta // {
    description = "An entirely open source Python library that allows you to manage your Razer peripherals on GNU/Linux";
  };
})
