{ callPackage, lib }:
let
  inherit (lib.attrsets) genAttrs mapAttrs;

  # Attribute set of {redist,cudatoolkit,cudatoolkit-legacy-runfile}.{*testGroup}.{*testName} = testConfig
  data =
    genAttrs
      [
        "redist"
        "cudatoolkit"
        "cudatoolkit-legacy-runfile"
      ]
      (
        testCudaPackageType:
        # Explicitly access Tests to avoid the extra attribute callPackage adds to the attribute set.
        (callPackage ./data.nix { inherit testCudaPackageType; }).Tests
      );

  testBuilder =
    testCudaPackageType: testGroup: testName: testConfig:
    callPackage ./generic.nix {
      inherit testCudaPackageType testGroup testName;
      testConfig = {
        # Provide default values for testConfig.
        enableCXX = testConfig.enableCXX or false;
        extraNativeBuildInputs = testConfig.extraNativeBuildInputs or [ ];
        extraBuildInputs = testConfig.extraBuildInputs or [ ];
        extraBrokenConditions = testConfig.extraBrokenConditions or { };
      };
    };

  testDrvs = mapAttrs (
    testCudaPackageType: mapAttrs (testGroup: mapAttrs (testBuilder testCudaPackageType testGroup))
  ) data;
in
testDrvs
