{
  lib,
  buildPythonPackage,
  dbus-python,
  fetchFromGitHub,
  numpy,
  openrazer-daemon,
  setuptools,
}:

let
  common = import ./common.nix { inherit lib fetchFromGitHub; };
in
buildPythonPackage (
  common
  // {
    pname = "openrazer";

    sourceRoot = "${common.src.name}/pylib";

    nativeBuildInputs = [ setuptools ];

    dependencies = [
      dbus-python
      numpy
      openrazer-daemon
    ];

    # no tests run
    doCheck = false;

    meta = common.meta // {
      description = "Entirely open source Python library that allows you to manage your Razer peripherals on GNU/Linux";
    };
  }
)
