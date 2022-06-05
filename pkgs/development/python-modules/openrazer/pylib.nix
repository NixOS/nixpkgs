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
buildPythonPackage (common // rec {
  pname = "openrazer";

  sourceRoot = "source/pylib";

  propagatedBuildInputs = [
    dbus-python
    numpy
    openrazer-daemon
  ];

  meta = common.meta // {
    description = "An entirely open source Python library that allows you to manage your Razer peripherals on GNU/Linux";
  };
})
