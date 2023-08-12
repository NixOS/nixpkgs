{ lib
, makeSetupHook
, zig
}:

makeSetupHook {
  name = "zig-hook";

  propagatedBuildInputs = [ zig ];

  substitutions = {
    zig_default_flags =
      if lib.versionAtLeast zig.version "0.11" then
        "-Doptimize=ReleaseSafe -Dcpu=baseline"
      else
        "-Drelease-safe=true -Dcpu=baseline";
  };

  passthru = { inherit zig; };

  meta = {
    description = "A setup hook for using the Zig compiler in Nixpkgs";
    inherit (zig.meta) maintainers platforms broken;
  };
} ./setup-hook.sh
