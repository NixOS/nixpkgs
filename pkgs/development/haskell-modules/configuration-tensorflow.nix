{ pkgs, haskellLib }:

with haskellLib;

self: super:
let
  # This contains updates to the dependencies, without which it would
  # be even more work to get it to build.
  # As of 2020-04, there's no new release in sight, which is why we're
  # pulling from Github.
  tensorflow-haskell = pkgs.fetchFromGitHub {
    owner = "tensorflow";
    repo = "haskell";
    rev = "555d90c43202d5a3021893013bfc8e2ffff58c97";
    sha256 = "uOuIeD4o+pcjvluTqyVU3GJUQ4e1+p3FhINJ9b6oK+k=";
    fetchSubmodules = true;
  };

  setTensorflowSourceRoot =
    dir: drv:
    (overrideCabal (drv: { src = tensorflow-haskell; }) drv).overrideAttrs (_oldAttrs: {
      sourceRoot = "${tensorflow-haskell.name}/${dir}";
    });
in
{
  tensorflow-proto = setTensorflowSourceRoot "tensorflow-proto" super.tensorflow-proto;

  tensorflow-opgen = setTensorflowSourceRoot "tensorflow-opgen" super.tensorflow-opgen;
}
