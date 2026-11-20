{
  pkgs,
  stdenv,
  lib,
  python,
}:

let
  inherit (lib)
    isFunction
    recursiveUpdate
    toExtension
    ;
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
    let
      boilerplateProblems = {
        # Handle `<pkg>.overridePythonAttrs` taking argument `disabled`
        meta.problems.buildPythonPackage-internal-disabled-overridePythonAttrs = { };
      };
      boilerplateDisabledAttrNames = [ "disabled" ];
    in
    f:
    lib.mirrorFunctionArgs f (
      origArgs':
      let
        # Transparently transition `disabled` -> `meta.problems.unsupportedPython`
        origArgs =
          if isFunction origArgs' then
            finalAttrs:
            let
              fixedOrigArgs' = origArgs' finalAttrs;
            in
            if fixedOrigArgs' ? disabled then handleDisabledArg fixedOrigArgs' else fixedOrigArgs'
          else if origArgs' ? disabled then
            handleDisabledArg origArgs'
          else
            origArgs';
        result = f origArgs;
        overrideWith =
          newArgs:
          # Only build a fixed-point when origArgs or newArgs are functions
          # or when we need to handle the `disabled` argument taken by `<pkg>.overridePyhtonAttrs`
          # to reduce allocation/GC.
          if isFunction origArgs || isFunction newArgs || newArgs ? disabled then
            # In-lined `lib.extends` with custom filter logic.
            finalAttrs:
            let
              previousArgs = if isFunction origArgs then origArgs finalAttrs else origArgs;
              updatingArgs = if isFunction newArgs then toExtension newArgs finalAttrs previousArgs else newArgs;
            in
            if updatingArgs ? disabled then
              # Remove disabled from newArgs
              # and add `meta.problems.buildPythonPackage-internal-disabled-overridePythonAttrs`.
              recursiveUpdate (
                previousArgs // removeAttrs updatingArgs boilerplateDisabledAttrNames
              ) boilerplateProblems
            else
              previousArgs // updatingArgs
          else
            origArgs // newArgs;
      in
      if lib.isAttrs result then
        result
        // {
          overridePythonAttrs = newArgs: makeOverridablePythonPackage f (overrideWith newArgs);
          overrideAttrs =
            newArgs: makeOverridablePythonPackage (args: (f args).overrideAttrs newArgs) origArgs;
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

  # When buildPython* is called,
  # convert { disabled = true; } to meta.problems.unsupportedPython
  # and remove the disabled argument.
  # This ensure that <pkg>.overridePythonAttrs can remediate `{ disabled = true; }`
  # by removing `unsupportedPython` from `meta.problems`.
  handleDisabledArg =
    let
      boilerplateProblems = {
        unsupportedPython = { };
      };
      ignoredNames = [ "disabled" ];
    in
    args:
    if args.disabled == args ? meta.problems.unsupportedPython then
      removeAttrs args ignoredNames
    else if args.disabled then
      removeAttrs args ignoredNames
      // {
        meta = args.meta or { } // {
          problems = args.meta.problems or { } // boilerplateProblems;
        };
      }
    else
      throw "${
        args.name or args.pname or "buildPythonPackage"
      }: { disabled = false; } conflicts with the presence of meta.problems.unsupportedPython";

  mkPythonDerivation =
    if python.isPy3k then
      ./mk-python-derivation.nix
    else
      # Python 2 build infrastructure lives with its only consumers (resholve, pypy27).
      ../../misc/resholve/python2/mk-python-derivation.nix;

  buildPythonPackage = makeOverridablePythonPackage (
    callPackage mkPythonDerivation {
      inherit namePrefix; # We want Python libraries to be named like e.g. "python3.6-${name}"
      inherit toPythonModule; # Libraries provide modules
      inherit (python) stdenv;
    }
  );

  buildPythonApplication = makeOverridablePythonPackage (
    callPackage mkPythonDerivation {
      namePrefix = ""; # Python applications should not have any prefix
      toPythonModule = x: x; # Application does not provide modules.
      inherit (python) stdenv;
    }
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
