{
  buildRedist,
  cudaMajorMinorVersion,
  cudaMajorVersion,
  cudaNamePrefix,
  lib,
  runCommand,
}:
let
  major = "cuda${cudaMajorVersion}";
  minor = "cuda${cudaMajorMinorVersion}";
  otherMinor = "cuda${cudaMajorVersion}.9999";
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
