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
  version = "0.9.0";
  sha256 = "15386c3a9e08823d6826c4491eaccc7b7254b1dc587a3b9ce60c350c3f990337";
  dlopen_patch = ./dlopen-paths-0.9.patch;
  inherit withXcffib;
} // args)
