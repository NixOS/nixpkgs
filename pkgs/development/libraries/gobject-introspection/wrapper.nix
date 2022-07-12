{ lib
, stdenv
, buildPackages
, gobject-introspection-unwrapped
, targetPackages
}:

# to build, run
# `nix build ".#pkgsCross.aarch64-multiplatform.buildPackages.gobject-introspection"`
gobject-introspection-unwrapped.overrideAttrs (previousAttrs: {
  pname = "gobject-introspection-wrapped";
  # failure in e.g. pkgsCross.aarch64-multiplatform.polkit
  # subprocess.CalledProcessError: Command '['/nix/store/...-prelink-unstable-2019-06-24/bin/prelink-rtld', '/build/source/build/tmp-introspectzp2ldkyk/PolkitAgent-1.0']' returned non-zero exit status 127.
  patches = previousAttrs.patches ++ [ ./giscanner-ignore-error-return-codes-from-ldd-wrapper.patch ];
  postFixup = (previousAttrs.postFixup or "") + ''
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
