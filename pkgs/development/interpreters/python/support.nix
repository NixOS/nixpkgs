{ pkgs
, python
, setuptools }:

with pkgs.lib;

self:

let
  modules = python.modules or {
    readline = null;
    sqlite3 = null;
    curses = null;
    curses_panel = null;
    crypt = null;
  };

in rec {

  inherit python;
  inherit setuptools; # Packages shouldn't depend explicitly on setuptools.
  inherit (python) mkPythonDerivation buildPythonPackage wrapPython ;
  inherit modules;

  pythonAtLeast = versionAtLeast python.pythonVersion;
  pythonOlder = versionOlder python.pythonVersion;
  isPy26 = python.majorVersion == "2.6";
  isPy27 = python.majorVersion == "2.7";
  isPy33 = python.majorVersion == "3.3";
  isPy34 = python.majorVersion == "3.4";
  isPy35 = python.majorVersion == "3.5";
  isPy36 = python.majorVersion == "3.6";
  isPyPy = python.executable == "pypy";
  isPy3k = strings.substring 0 1 python.majorVersion == "3";

  callPackage = pkgs.newScope self;

  buildPythonApplication = args: buildPythonPackage ({namePrefix="";} // args );

} // modules
