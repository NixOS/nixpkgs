{
  pkgs,
  stdenv,
  lib,
  python,
}:

let
  getOptionalAttrs =
    names: attrs: lib.getAttrs (lib.intersectLists names (lib.attrNames attrs)) attrs;

  getInstallCheckPhaseArgs =
    args:
    lib.mapAttrs'
      (name: value: {
        name = lib.replaceString "Check" "InstallCheck" name;
        inherit value;
      })
      (
        getOptionalAttrs [
          "doCheck"
          "preCheck"
          "postCheck"
        ] args
      )
    // getOptionalAttrs [
      "doInstallCheck"
      "preInstallCheck"
      "postInstallCheck"
    ] args
    // {
      nativeInstallCheckInputs = args.nativeCheckInputs or [ ] ++ args.nativeInstallCheckInputs or [ ];
      installCheckInputs = args.checkInputs or [ ] ++ args.installCheckInputs or [ ];
    }
    // lib.optionalAttrs (args ? installCheckPhase || args ? checkPhase) {
      installCheckPhase =
        lib.replaceStrings
          [ "runHook preCheck\n" "runHook postCheck\n" ]
          [ "runHook preInstallCheck\n" "runHook postInstallCheck\n" ]
          (args.installCheckPhase or args.checkPhase);
    };

  getCheckPhaseArgs =
    args:
    lib.mapAttrs'
      (name: value: {
        name = lib.replaceString "Install" "" name;
        inherit value;
      })
      (
        getOptionalAttrs [
          "doInstallCheck"
          "nativeInstallCheckInputs"
          "preInstallCheck"
          "postInstallCheck"
        ] args
      )
    // lib.optionalAttrs (args ? installCheckInputs) {
      checkInputs = args.installCheckInputs;
    }
    // lib.optionalAttrs (args ? installCheckPhase) {
      checkPhase =
        lib.replaceStrings
          [ "runHook preInstallCheck\n" "runHook postInstallCheck\n" ]
          [ "runHook preCheck\n" "runHook postCheck\n" ]
          args.installCheckPhase;
    };

  getOutArgs =
    args:
    let
      outArgsInstallCheck = getInstallCheckPhaseArgs args;
      outArgsCheck = getCheckPhaseArgs outArgsInstallCheck;
    in
    removeAttrs args (lib.attrNames outArgsCheck) // outArgsInstallCheck;
in

self:

let
  inherit (self) callPackage;

  namePrefix = python.libPrefix + "-";

  # Derivations built with `buildPythonPackage` can already be overridden with `override`, `overrideAttrs`, and `overrideDerivation`.
  # This function introduces `overridePythonAttrs` and it overrides the call to `buildPythonPackage`.
  #
  # Overridings specified through `overridePythonAttrs` will always be applied
  # before those specified by `overrideAttrs`, even if invoked after them.
  makeOverridablePythonPackage =
    f:
    lib.mirrorFunctionArgs f (
      origArgs:
      let
        installCheckPhaseArgsOrig = getInstallCheckPhaseArgs origArgs;
        checkPhaseArgsOrig = getCheckPhaseArgs installCheckPhaseArgsOrig;
        inArgs = origArgs // checkPhaseArgsOrig // installCheckPhaseArgsOrig;

        result = f (getOutArgs origArgs);
        overrideWith = newArgs: getOutArgs origArgs // getOutArgs (lib.toFunction newArgs inArgs);
      in
      if lib.isAttrs result then
        result
        // {
          overridePythonAttrs = newArgs: makeOverridablePythonPackage f (overrideWith newArgs);
          overrideAttrs =
            newArgs: makeOverridablePythonPackage (args: (f (getOutArgs args)).overrideAttrs newArgs) origArgs;
        }
      else
        result
    )
    // {
      # Support overriding `f` itself, e.g. `buildPythonPackage.override { }`.
      # Ensure `makeOverridablePythonPackage` is applied to the result.
      override = lib.mirrorFunctionArgs f.override (
        newArgs: makeOverridablePythonPackage (f.override newArgs)
      );
    };

  overrideStdenvCompat =
    f:
    lib.fix (
      f':
      lib.mirrorFunctionArgs f (
        args:
        if !(lib.isFunction args) && (args ? stdenv) then
          lib.warnIf (lib.oldestSupportedReleaseIsAtLeast 2511) ''
            Passing `stdenv` directly to `buildPythonPackage` or `buildPythonApplication` is deprecated. You should use their `.override` function instead, e.g:
              buildPythonPackage.override { stdenv = customStdenv; } { }
          '' (f'.override { inherit (args) stdenv; } (removeAttrs args [ "stdenv" ]))
        else
          f args
      )
      // {
        # Preserve the effect of overrideStdenvCompat when calling `buildPython*.override`.
        override = lib.mirrorFunctionArgs f.override (newArgs: overrideStdenvCompat (f.override newArgs));
      }
    );

  mkPythonDerivation =
    if python.isPy3k then ./mk-python-derivation.nix else ./python2/mk-python-derivation.nix;

  buildPythonPackage = makeOverridablePythonPackage (
    overrideStdenvCompat (
      callPackage mkPythonDerivation {
        inherit namePrefix; # We want Python libraries to be named like e.g. "python3.6-${name}"
        inherit toPythonModule; # Libraries provide modules
        inherit (python) stdenv;
      }
    )
  );

  buildPythonApplication = makeOverridablePythonPackage (
    overrideStdenvCompat (
      callPackage mkPythonDerivation {
        namePrefix = ""; # Python applications should not have any prefix
        toPythonModule = x: x; # Application does not provide modules.
        inherit (python) stdenv;
      }
    )
  );

  # Check whether a derivation provides a Python module.
  hasPythonModule = drv: drv ? pythonModule && drv.pythonModule == python;

  # Get list of required Python modules given a list of derivations.
  requiredPythonModules =
    drvs:
    let
      modules = lib.filter hasPythonModule drvs;
    in
    lib.unique (
      [ python ] ++ modules ++ lib.concatLists (lib.catAttrs "requiredPythonModules" modules)
    );

  # Create a PYTHONPATH from a list of derivations. This function recurses into the items to find derivations
  # providing Python modules.
  makePythonPath = drvs: lib.makeSearchPath python.sitePackages (requiredPythonModules drvs);

  removePythonPrefix = lib.removePrefix namePrefix;

  mkPythonEditablePackage = callPackage ./editable.nix { };

  mkPythonMetaPackage = callPackage ./meta-package.nix { };

  # Convert derivation to a Python module.
  toPythonModule =
    drv:
    drv.overrideAttrs (oldAttrs: {
      # Use passthru in order to prevent rebuilds when possible.
      passthru = (oldAttrs.passthru or { }) // {
        pythonModule = python;
        pythonPath = [ ]; # Deprecated, for compatibility.
        requiredPythonModules = builtins.addErrorContext "while calculating requiredPythonModules for ${drv.name or drv.pname}:" (
          requiredPythonModules drv.propagatedBuildInputs
        );
      };
    });

  # Convert a Python library to an application.
  toPythonApplication =
    drv:
    drv.overrideAttrs (oldAttrs: {
      passthru = (oldAttrs.passthru or { }) // {
        # Remove Python prefix from name so we have a "normal" name.
        # While the prefix shows up in the store path, it won't be
        # used by `nix-env`.
        name = removePythonPrefix oldAttrs.name;
        pythonModule = false;
      };
    });

  disabled =
    drv:
    throw "${
      removePythonPrefix (drv.pname or drv.name)
    } not supported for interpreter ${python.executable}";

  disabledIf = x: drv: if x then disabled drv else drv;

in
{
  inherit lib pkgs stdenv;
  inherit (python.passthru)
    isPy27
    isPy37
    isPy38
    isPy39
    isPy310
    isPy311
    isPy312
    isPy313
    isPy314
    isPy3k
    isPyPy
    pythonAtLeast
    pythonOlder
    ;
  inherit buildPythonPackage buildPythonApplication;
  inherit
    hasPythonModule
    requiredPythonModules
    makePythonPath
    disabled
    disabledIf
    ;
  inherit toPythonModule toPythonApplication;
  inherit mkPythonMetaPackage mkPythonEditablePackage;

  python = toPythonModule python;

  # Don't take pythonPackages from "global" pkgs scope to avoid mixing python versions.
  pythonPackages = self;
}
