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
        cpu = "-Dcpu=baseline";
        releaseType = if lib.versionAtLeast zig.version "0.11"
                      then "-Doptimize=ReleaseSafe"
                      else "-Drelease-safe=true";
      in
        lib.concatStringsSep " " [ cpu releaseType ];
  };

  passthru = { inherit zig; };

  meta = {
    description = "A setup hook for using the Zig compiler in Nixpkgs";
    inherit (zig.meta) maintainers platforms broken;
  };
} ./setup-hook.sh
