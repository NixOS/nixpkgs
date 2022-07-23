{ lib
, stdenv
, buildPackages
, targetPackages
, gobject-introspection-unwrapped
, ...
}@_args:

# to build, run
# 'nix build ".#pkgsCross.aarch64-multiplatform.buildPackages.gobject-introspection"'

let
  # ensure that `.override` works when gobject-introspection == gobject-introspection-wrapped
  args = builtins.removeAttrs _args [ "buildPackages" "targetPackages" "gobject-introspection-unwrapped" ];
  # passing this stdenv to `targetPackages...` breaks due to splicing not working in `.override``
  argsForTarget = builtins.removeAttrs args [ "stdenv" ];
in

(gobject-introspection-unwrapped.override args).overrideAttrs (_previousAttrs: {
  pname = "gobject-introspection-wrapped";
  postFixup = ''
    mv $dev/bin/g-ir-compiler $dev/bin/.g-ir-compiler-wrapped
    mv $dev/bin/g-ir-scanner $dev/bin/.g-ir-scanner-wrapped

    (
      export bash="${buildPackages.bash}/bin/bash"
      export emulator=${lib.escapeShellArg (stdenv.targetPlatform.emulator buildPackages)}
      export buildprelink="${buildPackages.prelink}/bin/prelink-rtld"

      export targetgir="${lib.getDev (targetPackages.gobject-introspection-unwrapped.override argsForTarget)}"

      substituteAll "${./wrappers/g-ir-compiler.sh}" "$dev/bin/g-ir-compiler"
      substituteAll "${./wrappers/g-ir-scanner.sh}" "$dev/bin/g-ir-scanner"
      chmod +x "$dev/bin/g-ir-compiler"
      chmod +x "$dev/bin/g-ir-scanner"
    )
  '';
})
