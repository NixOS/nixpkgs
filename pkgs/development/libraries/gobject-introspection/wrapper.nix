{ lib
, stdenv
, buildPackages
, targetPackages
, gobject-introspection-unwrapped
, ...
}@_args:

# to build, run
# `nix build ".#pkgsCross.aarch64-multiplatform.buildPackages.gobject-introspection"`

let
  # ensure that `.override` works when gobject-introspection == gobject-introspection-wrapped
  args = builtins.removeAttrs _args [ "buildPackages" "targetPackages" "gobject-introspection-unwrapped" ];
  # passing this stdenv to `targetPackages...` breaks due to splicing not working in `.override``
  argsForTarget = builtins.removeAttrs args [ "stdenv" ];
in

(gobject-introspection-unwrapped.override args).overrideAttrs (previousAttrs: {
  pname = "gobject-introspection-wrapped";
  depsTargetTargetPropagated = [ gobject-introspection-unwrapped ];
  postFixup = (previousAttrs.postFixup or "") + ''
    mv $dev/bin/g-ir-compiler $dev/bin/.g-ir-compiler-wrapped
    mv $dev/bin/g-ir-scanner $dev/bin/.g-ir-scanner-wrapped

    (
      export bash="${buildPackages.bash}"
      export emulator=${lib.escapeShellArg (stdenv.targetPlatform.emulator buildPackages)}
      export emulatorwrapper="$dev/bin/g-ir-scanner-qemuwrapper"
      export buildobjdump="${buildPackages.stdenv.cc.bintools}/bin/objdump"

      export targetgir="${lib.getDev (targetPackages.gobject-introspection-unwrapped.override argsForTarget)}"

      substituteAll "${./wrappers/g-ir-compiler.sh}" "$dev/bin/g-ir-compiler"
      substituteAll "${./wrappers/g-ir-scanner.sh}" "$dev/bin/g-ir-scanner"
      substituteAll "${./wrappers/g-ir-scanner-lddwrapper.sh}" "$dev/bin/g-ir-scanner-lddwrapper"
      substituteAll "${./wrappers/g-ir-scanner-qemuwrapper.sh}" "$dev/bin/g-ir-scanner-qemuwrapper"
      chmod +x $dev/bin/g-ir-*
    )
  ''
  # when cross-compiling and using the wrapper then when a package looks up the g_ir_X
  # variable with pkg-config they'll get the host version which can't be run
  # override the variable to use the absolute path to g_ir_X in PATH which can be run
  + ''
    cat >> $dev/nix-support/setup-hook <<-'EOF'
      override-pkg-config-gir-variables() {
        PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_G_IR_SCANNER="$(type -p g-ir-scanner)"
        PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_G_IR_COMPILER="$(type -p g-ir-compiler)"
        PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_G_IR_GENERATE="$(type -p g-ir-generate)"
        export PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_G_IR_SCANNER
        export PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_G_IR_COMPILER
        export PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_G_IR_GENERATE
      }

      preConfigureHooks+=(override-pkg-config-gir-variables)
    EOF
  '';
})
