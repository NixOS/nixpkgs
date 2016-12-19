{ stdenv, callPackage, fetchFromGitHub, python, ... } @ args:
with stdenv.lib;
let
  version = "3.14.5.10";
  sha256 = "08vhl84166x13b3cbx8y0g99yqx772zd33gawsa1nxqkyrykql6k";
in
(callPackage ./generic.nix (args // {
  inherit version sha256;
})).overrideDerivation (oldAttrs:{
  patchPhase = [
    oldAttrs.patchPhase
    "sed -i 's,#!/usr/bin/python,#!${python}/bin/python,' build/gyp_v8"
  ];

  # http://code.google.com/p/v8/issues/detail?id=2149
  NIX_CFLAGS_COMPILE = concatStringsSep " " [
    oldAttrs.NIX_CFLAGS_COMPILE
    "-Wno-unused-local-typedefs"
    "-Wno-aggressive-loop-optimizations"
  ];

  src = fetchFromGitHub {
    owner = "v8";
    repo = "v8";
    rev = "${version}";
    inherit sha256;
  };
})
