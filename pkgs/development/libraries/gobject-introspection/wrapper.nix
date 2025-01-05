{
  lib,
  stdenv,
  buildPackages,
  targetPackages,
  gobject-introspection-unwrapped,
  ...
}@_args:

# to build, run
# `nix build ".#pkgsCross.aarch64-multiplatform.buildPackages.gobject-introspection"`

# a comment for both depsTargetTargetPropagated's
# add self to buildInputs to avoid needing to add gobject-introspection to buildInputs in addition to nativeBuildInputs
# builds use target-pkg-config to look for gobject-introspection instead of just looking for binaries in $PATH

let
  # ensure that `.override` works
  args = builtins.removeAttrs _args [
    "buildPackages"
    "targetPackages"
    "gobject-introspection-unwrapped"
  ];
  # passing this stdenv to `targetPackages...` breaks due to splicing not working in `.override``
  argsForTarget = builtins.removeAttrs args [ "stdenv" ];

  overriddenUnwrappedGir = gobject-introspection-unwrapped.override args;
  # if we have targetPackages.gobject-introspection then propagate that
  overridenTargetUnwrappedGir =
    if targetPackages ? gobject-introspection-unwrapped then
      targetPackages.gobject-introspection-unwrapped.override argsForTarget
    else
      overriddenUnwrappedGir;
in

# wrap both pkgsCrossX.buildPackages.gobject-introspection and {pkgs,pkgsSomethingExecutableOnBuildSystem).buildPackages.gobject-introspection
if
  (!stdenv.hostPlatform.canExecute stdenv.targetPlatform)
  && stdenv.targetPlatform.emulatorAvailable buildPackages
then
  overriddenUnwrappedGir.overrideAttrs (previousAttrs: {

    pname = "gobject-introspection-wrapped";
    passthru = previousAttrs.passthru // {
      unwrapped = overriddenUnwrappedGir;
    };
    dontStrip = true;
    depsTargetTargetPropagated = [ overridenTargetUnwrappedGir ];
    buildCommand =
      ''
        eval fixupPhase
        ${lib.concatMapStrings (output: ''
          mkdir -p ${"$" + "${output}"}
          ${lib.getExe buildPackages.xorg.lndir} ${overriddenUnwrappedGir.${output}} ${"$" + "${output}"}
        '') overriddenUnwrappedGir.outputs}

        cp $dev/bin/g-ir-compiler $dev/bin/.g-ir-compiler-wrapped
        cp $dev/bin/g-ir-scanner $dev/bin/.g-ir-scanner-wrapped

        (
          rm "$dev/bin/g-ir-compiler"
          rm "$dev/bin/g-ir-scanner"
          export bash="${buildPackages.bash}"
          export emulator=${lib.escapeShellArg (stdenv.targetPlatform.emulator buildPackages)}
          export emulatorwrapper="$dev/bin/g-ir-scanner-qemuwrapper"
          export buildlddtree="${buildPackages.pax-utils}/bin/lddtree"

          export targetgir="${lib.getDev overridenTargetUnwrappedGir}"

          substituteAll "${./wrappers/g-ir-compiler.sh}" "$dev/bin/g-ir-compiler"
          substituteAll "${./wrappers/g-ir-scanner.sh}" "$dev/bin/g-ir-scanner"
          substituteAll "${./wrappers/g-ir-scanner-lddwrapper.sh}" "$dev/bin/g-ir-scanner-lddwrapper"
          substituteAll "${./wrappers/g-ir-scanner-qemuwrapper.sh}" "$dev/bin/g-ir-scanner-qemuwrapper"
          chmod +x $dev/bin/g-ir-compiler
          chmod +x $dev/bin/g-ir-scanner*
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
else
  overriddenUnwrappedGir.overrideAttrs (previousAttrs: {
    pname = "gobject-introspection-wrapped";
    passthru = previousAttrs.passthru // {
      unwrapped = overriddenUnwrappedGir;
    };
    dontStrip = true;
    # Conditional is for `pkgsCross.x86_64-freebsd.pkgsBuildHost.gobject-introspection` `error: Don't know how to run x86_64-unknown-freebsd executables.`
    # `pkgsCross.x86_64-freebsd.buildPackages.python3.withPackages (pp: [ pp.pygobject3 ])`
    # Using the python module does not need this propagation
    depsTargetTargetPropagated = lib.optionals (stdenv.targetPlatform.emulatorAvailable buildPackages) [
      overridenTargetUnwrappedGir
    ];
    buildCommand = ''
      eval fixupPhase
      ${lib.concatMapStrings (output: ''
        mkdir -p ${"$" + "${output}"}
        ${lib.getExe buildPackages.xorg.lndir} ${overriddenUnwrappedGir.${output}} ${"$" + "${output}"}
      '') overriddenUnwrappedGir.outputs}
    '';
  })
