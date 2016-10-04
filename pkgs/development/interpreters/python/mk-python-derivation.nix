/* Generic builder for Python packages that come without a setup.py. */

{ lib
, python
, wrapPython
, setuptools
, unzip
, ensureNewerSourcesHook
}:

{ name

# by default prefix `name` e.g. "python3.3-${name}"
, namePrefix ? python.libPrefix + "-"

# Dependencies for building the package
, buildInputs ? []

# Dependencies needed for running the checkPhase.
# These are added to buildInputs when doCheck = true.
, checkInputs ? []

# propagate build dependencies so in case we have A -> B -> C,
# C can import package A propagated by B
, propagatedBuildInputs ? []

# DEPRECATED: use propagatedBuildInputs
, pythonPath ? []

# used to disable derivation, useful for specific python versions
, disabled ? false

# Raise an error if two packages are installed with the same name
, catchConflicts ? true

# Additional arguments to pass to the makeWrapper function, which wraps
# generated binaries.
, makeWrapperArgs ? []

, meta ? {}

, passthru ? {}

, doCheck ? false

, ... } @ attrs:


# Keep extra attributes from `attrs`, e.g., `patchPhase', etc.
if disabled
then throw "${name} not supported for interpreter ${python.executable}"
else

python.stdenv.mkDerivation (builtins.removeAttrs attrs ["disabled"] // {

  name = namePrefix + name;

  inherit pythonPath;

  buildInputs = [ wrapPython ] ++ buildInputs ++ pythonPath
    ++ [ (ensureNewerSourcesHook { year = "1980"; }) ]
    ++ (lib.optional (lib.hasSuffix "zip" attrs.src.name or "") unzip)
    ++ lib.optionals doCheck checkInputs;

  # propagate python/setuptools to active setup-hook in nix-shell
  propagatedBuildInputs = propagatedBuildInputs ++ [ python setuptools ];

  # Python packages don't have a checkPhase, only an installCheckPhase
  doCheck = false;
  doInstallCheck = doCheck;

  postFixup = attrs.postFixup or ''
    wrapPythonPrograms
  '' + lib.optionalString catchConflicts ''
    # check if we have two packages with the same name in closure and fail
    # this shouldn't happen, something went wrong with dependencies specs
    ${python.interpreter} ${./catch_conflicts.py}
  '';

  passthru = {
    inherit python; # The python interpreter
  } // passthru;

  meta = with lib.maintainers; {
    # default to python's platforms
    platforms = python.meta.platforms;
  } // meta // {
    # add extra maintainer(s) to every package
    maintainers = (meta.maintainers or []) ++ [ chaoflow domenkozar ];
    # a marker for release utilities to discover python packages
    isBuildPythonPackage = python.meta.platforms;
  };
})


