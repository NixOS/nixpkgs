{ lib
, makeSetupHook
, zig
}:

makeSetupHook {
  name = "zig-hook";

  propagatedBuildInputs = [ zig ];

  passthru = { inherit zig; };

  meta = {
    description = "A setup hook for using the Zig compiler in Nixpkgs";
    inherit (zig.meta) maintainers platforms badPlatforms broken;
  };
} ./setup-hook.sh
