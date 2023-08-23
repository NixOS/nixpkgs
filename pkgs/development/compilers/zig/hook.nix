{ lib
, makeSetupHook
, zig
}:

makeSetupHook {
  name = "zig-hook";

  propagatedBuildInputs = [ zig ];

  substitutions = {
    zig_default_flags =
      let
        releaseType =
          if lib.versionAtLeast zig.version "0.11" then
            "-Doptimize=ReleaseSafe"
          else
            "-Drelease-safe=true";
      in
      [ "-Dcpu=baseline" releaseType ];
  };

  passthru = { inherit zig; };

  meta = {
    description = "A setup hook for using the Zig compiler in Nixpkgs";
    inherit (zig.meta) maintainers platforms broken;
  };
} ./setup-hook.sh
