{stdenv, lib, fetchurl}:

{elmPackages, versionsDat}:

let
  makeDotElm = import ./makeDotElm.nix {inherit stdenv lib fetchurl versionsDat;};

in
''
  export ELM_HOME=`pwd`/.elm
'' + (makeDotElm "0.19.0" elmPackages)
