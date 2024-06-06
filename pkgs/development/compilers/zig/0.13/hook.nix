{
  lib,
  makeSetupHook,
  zig,
}:

makeSetupHook {
  name = "zig-hook";

  propagatedBuildInputs = [ zig ];

  substitutions = {
    # This zig_default_flags below is meant to avoid CPU feature impurity in
    # Nixpkgs. However, this flagset is "unstable": it is specifically meant to
    # be controlled by the upstream development team - being up to that team
    # exposing or not that flags to the outside (especially the package manager
    # teams).
    zig_default_flags = [
      "-Dcpu=baseline"
      "--release=safe"
    ];
  };

  passthru = {
    inherit zig;
  };

  meta = {
    description = "A setup hook for using the Zig compiler in Nixpkgs";
    inherit (zig.meta) maintainers platforms broken;
  };
} ./setup-hook.sh
