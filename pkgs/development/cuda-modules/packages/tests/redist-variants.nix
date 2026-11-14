{
  buildRedist,
  cudaMajorMinorPatchVersion,
  cudaMajorMinorVersion,
  cudaMajorVersion,
  cudaNamePrefix,
  lib,
  runCommand,
}:
let
  major = "cuda${cudaMajorVersion}";
  minor = "cuda${cudaMajorMinorVersion}";
  patch = "cuda${cudaMajorMinorPatchVersion}";
  otherMinor = "cuda${cudaMajorVersion}.9999";
  otherPatch = "cuda${cudaMajorMinorVersion}.9999";
  payload = name: {
    relative_path = "${name}.tar.xz";
    sha256 = lib.fakeSha256;
  };
  select =
    release:
    (buildRedist {
      redistName = "cuda";
      pname = "variant-selection-test";
      release = {
        version = "1.0";
      }
      // release;
    }).supportedReleases;
  failures = lib.runTests {
    testPatchPreferenceAndMinorFallback = {
      expr = select {
        cuda_variant = [
          cudaMajorVersion
          cudaMajorMinorVersion
          cudaMajorMinorPatchVersion
          "${cudaMajorMinorVersion}.9999"
        ];
        linux-x86_64 = {
          ${major} = payload "major";
          ${minor} = payload "minor";
          ${patch} = payload "patch";
          ${otherPatch} = payload "wrong-patch";
        };
        linux-sbsa = {
          ${minor} = payload "arm-minor";
          ${otherPatch} = payload "wrong-patch";
        };
      };
      expected = {
        linux-x86_64 = payload "patch";
        linux-sbsa = payload "arm-minor";
      };
    };
    testRejectOtherPatch = {
      expr = select {
        cuda_variant = [ "${cudaMajorMinorVersion}.9999" ];
        linux-x86_64.${otherPatch} = payload "wrong-patch";
      };
      expected = { };
    };
    testExactMinor = {
      expr = select {
        cuda_variant = [ cudaMajorMinorVersion ];
        linux-x86_64.${minor} = payload "minor";
        linux-sbsa.${minor} = payload "arm-minor";
      };
      expected = {
        linux-x86_64 = payload "minor";
        linux-sbsa = payload "arm-minor";
      };
    };
    testMajorFallbackAndMinorPreference = {
      expr = select {
        cuda_variant = [
          cudaMajorVersion
          cudaMajorMinorVersion
        ];
        linux-x86_64 = {
          ${major} = payload "major";
          ${minor} = payload "minor";
        };
        linux-sbsa.${major} = payload "arm-major";
      };
      expected = {
        linux-x86_64 = payload "minor";
        linux-sbsa = payload "arm-major";
      };
    };
    testRejectOtherMinor = {
      expr = select {
        cuda_variant = [ "${cudaMajorVersion}.9999" ];
        linux-x86_64.${otherMinor} = payload "wrong-minor";
      };
      expected = { };
    };
    testUnversionedPlatform = {
      expr = select { linux-x86_64 = payload "unversioned"; };
      expected = {
        linux-x86_64 = payload "unversioned";
      };
    };
    testUniversalPriority = {
      expr = select {
        linux-all = payload "universal";
        linux-x86_64 = payload "platform";
      };
      expected = {
        linux-all = payload "universal";
      };
    };
    testSourcePriority = {
      expr = select {
        source = payload "source";
        linux-all = payload "universal";
        linux-x86_64 = payload "platform";
      };
      expected = {
        source = payload "source";
      };
    };
  };
in
assert lib.assertMsg (failures == [ ]) (builtins.toJSON failures);
runCommand "${cudaNamePrefix}-tests-redist-variants" { } ''
  touch "$out"
''
