{ lib
, stdenv
, buildPackages
, gobject-introspection-unwrapped
, targetPackages
}:

# to build, run
# `nix build ".#pkgsCross.aarch64-multiplatform.buildPackages.gobject-introspection"`
gobject-introspection-unwrapped.overrideAttrs (_previousAttrs: {
  pname = "gobject-introspection-wrapped";
  postFixup = ''
    mv $dev/bin/g-ir-compiler $dev/bin/.g-ir-compiler-wrapped
    mv $dev/bin/g-ir-scanner $dev/bin/.g-ir-scanner-wrapped

    (
      export bash="${buildPackages.bash}/bin/bash"
      export emulator=${lib.escapeShellArg (stdenv.targetPlatform.emulator buildPackages)}
      export buildprelink="${buildPackages.prelink}/bin/prelink-rtld"

      export targetgir="${lib.getDev targetPackages.gobject-introspection-unwrapped}"

      substituteAll "${./wrappers/g-ir-compiler.sh}" "$dev/bin/g-ir-compiler"
      substituteAll "${./wrappers/g-ir-scanner.sh}" "$dev/bin/g-ir-scanner"
      chmod +x "$dev/bin/g-ir-compiler"
      chmod +x "$dev/bin/g-ir-scanner"
    )
  '';
})
