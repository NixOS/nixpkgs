{
  pkgs,
  stdenv,
  lib,
  python,
}:

let
  inherit (lib)
    isFunction
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
    isInitialCall: f:
    lib.mirrorFunctionArgs f (
      origArgs':
      let
        origArgs =
          if isFunction origArgs' then
            finalAttrs:
            let
              previousArgs = origArgs' finalAttrs;
            in
            if previousArgs ? disabled then handleDisabledArg previousArgs else previousArgs
          else if isInitialCall && origArgs' ? disabled then
            handleDisabledArg origArgs'
          else
            origArgs';
        result = f origArgs;
        overrideWith =
          # Preserve the plain arguments whenever possible,
          # as `overrideStdenvCompat` works more reliably with `args.stdenv`
          # than `result.__stdenvPythonCompat`.
          # TODO(@ShamrockLee): After `overrideStdenvCompat` is fully deprecated,
          # simplify as
          # ```nix
          # newArgs: lib.extends (lib.toExtension newArgs) origArgs
          # ```
          if lib.isFunction origArgs then
            newArgs: lib.extends (lib.toExtension newArgs) origArgs
          else
            newArgs:
            if !(lib.isFunction newArgs) then
              origArgs // newArgs
            else if !(lib.isFunction (newArgs origArgs)) then
              origArgs // newArgs origArgs
            else
              finalAttrs: origArgs // newArgs finalAttrs origArgs;
      in
      if lib.isAttrs result then
        result
        // {
          overridePythonAttrs = newArgs: makeOverridablePythonPackage false f (overrideWith newArgs);
          overrideAttrs =
            newArgs: makeOverridablePythonPackage isInitialCall (args: (f args).overrideAttrs newArgs) origArgs;
        }
      else
        result
    )
    // {
      # Support overriding `f` itself, e.g. `buildPythonPackage.override { }`.
      # Ensure `makeOverridablePythonPackage` is applied to the result.
      override = lib.mirrorFunctionArgs f.override (
        newArgs: makeOverridablePythonPackage isInitialCall (f.override newArgs)
      );
    };

  overrideStdenvCompat =
    f:
    lib.fix (
      f':
      lib.mirrorFunctionArgs f (
        args:
        let
          result = f args;
          handleStdenvArg =
            attrs: attrName:
            let
              name = attrs.pname or (lib.getName (attrs.name or "<unnamed>"));
              pos = attrs.__stdenvPythonCompatPos or (builtins.unsafeGetAttrPos attrName attrs);
              msg = [
                "${name}: Passing `stdenv` directly to `buildPythonPackage` or `buildPythonApplication` is deprecated. You should use their `.override` function instead, e.g:"
                "  buildPythonPackage.override { stdenv = customStdenv; } { }"
              ]
              ++ lib.optionals (pos != null) [
                "`stdenv` argument found at ${pos.file}:${toString pos.line}"
              ];
            in
            lib.warnIf (lib.oldestSupportedReleaseIsAtLeast 2511) (lib.concatLines msg) attrs.${attrName};
        in
        if lib.isFunction args && result ? __stdenvPythonCompat then
          # Less reliable, as constructing with the wrong `stdenv` might lead to evaluation errors in the package definition.
          f'.override { stdenv = handleStdenvArg result "__stdenvPythonCompat"; } (
            finalAttrs: removeAttrs (args finalAttrs) [ "stdenv" ]
          )
        else if (!lib.isFunction args) && (args ? stdenv) then
          # More reliable, but only works when args is not `(finalAttrs: { })`
          f'.override { stdenv = handleStdenvArg args "stdenv"; } (removeAttrs args [ "stdenv" ])
        else
          result
      )
      // {
        # Preserve the effect of overrideStdenvCompat when calling `buildPython*.override`.
        override = lib.mirrorFunctionArgs f.override (newArgs: overrideStdenvCompat (f.override newArgs));
      }
    );

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

  buildPythonPackage = makeOverridablePythonPackage true (
    overrideStdenvCompat (
      callPackage mkPythonDerivation {
        inherit namePrefix; # We want Python libraries to be named like e.g. "python3.6-${name}"
        inherit toPythonModule; # Libraries provide modules
        inherit (python) stdenv;
      }
    )
  );

  buildPythonApplication = makeOverridablePythonPackage true (
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
