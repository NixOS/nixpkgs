{ pkgs
, stdenv
, lib
, python
}:

self:

let
  inherit (self) callPackage;
  inherit (python.passthru) isPy27 isPy37 isPy38 isPy39 isPy310 isPy311 isPy3k isPyPy pythonAtLeast pythonOlder;

  namePrefix = python.libPrefix + "-";

  # Derivations built with `buildPythonPackage` can already be overridden with `override`, `overrideAttrs`, and `overrideDerivation`.
  # This function introduces `overridePythonAttrs` and it overrides the call to `buildPythonPackage`.
  makeOverridablePythonPackage = f: origArgs:
    let
      ff = f origArgs;
      overrideWith = newArgs: origArgs // (if pkgs.lib.isFunction newArgs then newArgs origArgs else newArgs);
    in
      if builtins.isAttrs ff then (ff // {
        overridePythonAttrs = newArgs: makeOverridablePythonPackage f (overrideWith newArgs);
      })
      else if builtins.isFunction ff then {
        overridePythonAttrs = newArgs: makeOverridablePythonPackage f (overrideWith newArgs);
        __functor = self: ff;
      }
      else ff;

  buildPythonPackage = makeOverridablePythonPackage (lib.makeOverridable (callPackage ./mk-python-derivation.nix {
    inherit namePrefix;     # We want Python libraries to be named like e.g. "python3.6-${name}"
    inherit toPythonModule; # Libraries provide modules
  }));

  buildPythonApplication = makeOverridablePythonPackage (lib.makeOverridable (callPackage ./mk-python-derivation.nix {
    namePrefix = "";        # Python applications should not have any prefix
    toPythonModule = x: x;  # Application does not provide modules.
  }));

  # See build-setupcfg/default.nix for documentation.
  buildSetupcfg = import ../../../build-support/build-setupcfg self;

  fetchPypi = callPackage ./fetchpypi.nix { };

  # Check whether a derivation provides a Python module.
  hasPythonModule = drv: drv?pythonModule && drv.pythonModule == python;

  # Get list of required Python modules given a list of derivations.
  requiredPythonModules = drvs: let
    modules = lib.filter hasPythonModule drvs;
  in lib.unique ([python] ++ modules ++ lib.concatLists (lib.catAttrs "requiredPythonModules" modules));

  # Create a PYTHONPATH from a list of derivations. This function recurses into the items to find derivations
  # providing Python modules.
  makePythonPath = drvs: lib.makeSearchPath python.sitePackages (requiredPythonModules drvs);

  removePythonPrefix = lib.removePrefix namePrefix;

  # Convert derivation to a Python module.
  toPythonModule = drv:
    drv.overrideAttrs( oldAttrs: {
      # Use passthru in order to prevent rebuilds when possible.
      passthru = (oldAttrs.passthru or {})// {
        pythonModule = python;
        pythonPath = [ ]; # Deprecated, for compatibility.
        requiredPythonModules = requiredPythonModules drv.propagatedBuildInputs;
      };
    });

  # Convert a Python library to an application.
  toPythonApplication = drv:
    drv.overrideAttrs( oldAttrs: {
      passthru = (oldAttrs.passthru or {}) // {
        # Remove Python prefix from name so we have a "normal" name.
        # While the prefix shows up in the store path, it won't be
        # used by `nix-env`.
        name = removePythonPrefix oldAttrs.name;
        pythonModule = false;
      };
    });

  disabled = drv: throw "${removePythonPrefix (drv.pname or drv.name)} not supported for interpreter ${python.executable}";

  disabledIf = x: drv: if x then disabled drv else drv;

in {

  inherit lib pkgs stdenv;
  inherit (python.passthru) isPy27 isPy37 isPy38 isPy39 isPy310 isPy311 isPy3k isPyPy pythonAtLeast pythonOlder;
  inherit buildPythonPackage buildPythonApplication;
  inherit fetchPypi;
  inherit hasPythonModule requiredPythonModules makePythonPath disabled disabledIf;
  inherit toPythonModule toPythonApplication;
  inherit buildSetupcfg;

  python = toPythonModule python;
  # Dont take pythonPackages from "global" pkgs scope to avoid mixing python versions
  pythonPackages = self;

  # Remove?
  recursivePthLoader = toPythonModule (callPackage ../../../development/python-modules/recursive-pth-loader { });

}
