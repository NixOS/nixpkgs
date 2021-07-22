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
, pytest-runner
, glibcLocales
, cairo
, cffi
, numpy
, withXcffib ? false, xcffib
, python
, glib
, gdk-pixbuf
}@args:

import ./generic.nix ({
  version = "1.2.0";
  sha256 = "sha256-mpebUAxkyBef7ChvM36P5kTsovLNBYYM4LYtJfIuoUA=";
  dlopen_patch = ./dlopen-paths.patch;
  disabled = pythonOlder "3.5";
  inherit withXcffib;
} // args)
