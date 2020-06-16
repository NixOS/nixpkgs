{ stdenv, darwin, goPackage, pkgs }:

let
  go = pkgs.${goPackage};
in
  stdenv.mkDerivation {
    name = "compile-cgo-stdlib";
    meta.timeout = 60;
    buildCommand = ''
      export GOCACHE=$TMPDIR/cache
      ${go}/bin/go build -x -o $TMPDIR/prog ${./file.go}
      $TMPDIR/prog | grep "hello"
      touch $out
    '';
  }
