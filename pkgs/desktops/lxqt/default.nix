{ pkgs, newScope, fetchFromGitHub }:

let
  callPackage = newScope self;

  self = rec {

    # For compiling information, see:
    # - https://github.com/lxde/lxqt/wiki/Building-from-source  

in self
