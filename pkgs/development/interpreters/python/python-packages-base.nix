{
  pkgs,
  stdenv,
  lib,
  python,
}:

self:

let
  inherit (self) callPackage;

  namePrefix = python.libPrefix + "-";

  # Derivations built with `buildPythonPackage` can already be overridden with `override`, `overrideAttrs`, and `overrideDerivation`.
  # This function introduces `overridePythonAttrs` and it overrides the call to `buildPythonPackage`.
  makeOverridablePythonPackage =
    f:
    lib.mirrorFunctionArgs f (
      origArgs:
      let
        args = lib.fix (
          lib.extends (_: previousAttrs: {
            passthru = (previousAttrs.passthru or { }) // {
              overridePythonAttrs = newArgs: makeOverridablePythonPackage f (overrideWith newArgs);
            };
          }) (_: origArgs)
        );
        result = f args;
        overrideWith = newArgs: args // (if pkgs.lib.isFunction newArgs then newArgs args else newArgs);
      in
      if builtins.isAttrs result then
        result
      else if builtins.isFunction result then
        {
          overridePythonAttrs = newArgs: makeOverridablePythonPackage f (overrideWith newArgs);
          __functor = self: result;
        }
      else
        result
    )
    // {
      # Support overriding `f` itself, e.g. `buildPythonPackage.override { }`.
      # Ensure `makeOverridablePythonPackage` is applied to the result.
      override = lib.mirrorFunctionArgs f.override (fdrv: makeOverridablePythonPackage (f.override fdrv));
    };

  overrideStdenvCompat =
    f:
    lib.setFunctionArgs (
      args:
      if !(lib.isFunction args) && (args ? stdenv) then
        lib.warnIf (lib.oldestSupportedReleaseIsAtLeast 2511) ''
          Passing `stdenv` directly to `buildPythonPackage` or `buildPythonApplication` is deprecated. You should use their `.override` function instead, e.g:
            buildPythonPackage.override { stdenv = customStdenv; } { }
        '' (f.override { stdenv = args.stdenv; } args)
      else
        f args
    ) (removeAttrs (lib.functionArgs f) [ "stdenv" ])
    // {
      # Intentionally drop the effect of overrideStdenvCompat when calling `buildPython*.override`.
      inherit (f) override;
    };

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
