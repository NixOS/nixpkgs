# FIXME: make gdk-pixbuf dependency optional
{ stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, lib
, substituteAll
, makeFontsConf
, freefont_ttf
, pytest
, pytestrunner
, glibcLocales
, cairo
, cffi
, withXcffib ? false, xcffib
, python
, glib
, gdk-pixbuf
}@args:

import ./generic.nix ({
  version = "1.0.2";
  sha256 = "01ac51ae12c4324ca5809ce270f9dd1b67f5166fe63bd3e497e9ea3ca91946ff";
  dlopen_patch = ./dlopen-paths.patch;
  disabled = pythonOlder "3.5";
  inherit withXcffib;
} // args)
