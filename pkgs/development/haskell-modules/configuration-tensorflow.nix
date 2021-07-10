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
    rev = "d088e30b80f1508281e400975bec9d14b431a22c";
    sha256 = "0lshsvajy5b67dkz0aaja4aj61q2x4dl526jx3i4c3sqjyz2vb7r";
    fetchSubmodules = true;
  };

  setTensorflowSourceRoot = dir: drv:
    (overrideCabal drv (drv: { src = tensorflow-haskell; }))
      .overrideAttrs (_oldAttrs: {sourceRoot = "source/${dir}";});
in
{
  tensorflow-proto = doJailbreak (setTensorflowSourceRoot "tensorflow-proto" super.tensorflow-proto);

  tensorflow = (setTensorflowSourceRoot "tensorflow" super.tensorflow).override {
    # the "regular" Python package does not seem to include the binary library
    libtensorflow = pkgs.libtensorflow-bin;
  };

  tensorflow-core-ops = setTensorflowSourceRoot "tensorflow-core-ops" super.tensorflow-core-ops;

  tensorflow-logging = setTensorflowSourceRoot "tensorflow-logging" super.tensorflow-logging;

  tensorflow-opgen = setTensorflowSourceRoot "tensorflow-opgen" super.tensorflow-opgen;

  tensorflow-ops = setTensorflowSourceRoot "tensorflow-ops" super.tensorflow-ops;
}
