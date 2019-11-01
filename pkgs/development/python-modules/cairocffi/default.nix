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
  version = "1.1.0";
  sha256 = "1nq53f5jipgy9jgyfxp43j40qfbmrhgn1cj8bp5rrb3liy3wbh7i";
  dlopen_patch = ./dlopen-paths.patch;
  disabled = pythonOlder "3.5";
  inherit withXcffib;
} // args)
