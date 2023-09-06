{ lib }:
let platforms = import ../platforms.nix { inherit lib; };

  inherit (platforms) knownFridaHosts platformToFridaHost;

  test = nixSystem: fridaSystem:
    let elaborated = lib.systems.elaborate nixSystem; in {
      name = "test_${elaborated.config}";
      value = {
        expr = platformToFridaHost elaborated;
        expected = builtins.seq
          (lib.assertOneOf "tested fridaSystem" fridaSystem knownFridaHosts)
          fridaSystem;
      };
    };
  tests = builtins.listToAttrs (with lib.systems.examples; [
    (test "x86_64-linux" "linux-x86_64")
    (test "aarch64-linux" "linux-arm64")
    (test aarch64-android "android-arm64")
    (test x86_64-freebsd "freebsd-x86_64")
    (test aarch64-multiplatform-musl "linux-arm64-musl")
    # mystery: should this be arm64e? does nixpkgs even represent the CPU revision?
    (test iphone64 "ios-arm64")
  ]);
in
lib.runTests tests
