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

    # Because of this hurdle, @andrewrk from Zig Software Foundation proposed
    # some solutions for this issue. Hopefully they will be implemented in
    # future releases of Zig. When this happens, this flagset should be
    # revisited accordingly.

    # Below are some useful links describing the discovery process of this 'bug'
    # in Nixpkgs:

    # https://github.com/NixOS/nixpkgs/issues/169461
    # https://github.com/NixOS/nixpkgs/issues/185644
    # https://github.com/NixOS/nixpkgs/pull/197046
    # https://github.com/NixOS/nixpkgs/pull/241741#issuecomment-1624227485
    # https://github.com/ziglang/zig/issues/14281#issuecomment-1624220653

    zig_default_flags =
      let
        releaseType =
          if lib.versionAtLeast zig.version "0.12" then
            "--release=safe"
          else if lib.versionAtLeast zig.version "0.11" then
            "-Doptimize=ReleaseSafe"
          else
            "-Drelease-safe=true";
      in
      [
        "-Dcpu=baseline"
        releaseType
      ];
  };

  passthru = {
    inherit zig;
  };

  meta = {
    description = "Setup hook for using the Zig compiler in Nixpkgs";
    inherit (zig.meta) maintainers platforms broken;
  };
} ./setup-hook.sh
