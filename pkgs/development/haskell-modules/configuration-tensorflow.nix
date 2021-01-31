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
    rev = "6b19e5472211805db0daae8df09f77d37e111659";
    sha256 = "0k49agn4d5h0fb4hdvlg6l31bapm92fbvb8y5ahi2927rc21z75z";
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
