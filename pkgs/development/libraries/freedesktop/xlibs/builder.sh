#! /bin/sh -e

. $stdenv/setup

mkdir $out
mkdir $out/nix-support
echo "$propagatedBuildInputs" > $out/nix-support/propagated-build-inputs
