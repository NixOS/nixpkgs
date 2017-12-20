# Generic builder.

{ lib
, python
, wrapPython
, setuptools
, unzip
, ensureNewerSourcesHook
# Whether the derivation provides a Python module or not.
, toPythonModule
, namePrefix
}:

{ name ? "${attrs.pname}-${attrs.version}"

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

# Skip wrapping of python programs altogether
, dontWrapPythonPrograms ? false

# Remove bytecode from bin folder.
# When a Python script has the extension `.py`, bytecode is generated
# Typically, executables in bin have no extension, so no bytecode is generated.
# However, some packages do provide executables with extensions, and thus bytecode is generated.
, removeBinBytecode ? true

, meta ? {}

, passthru ? {}

, doCheck ? false

, ... } @ attrs:


# Keep extra attributes from `attrs`, e.g., `patchPhase', etc.
if disabled
then throw "${name} not supported for interpreter ${python.executable}"
else

toPythonModule (python.stdenv.mkDerivation (builtins.removeAttrs attrs [
    "disabled" "checkInputs" "doCheck" "doInstallCheck" "dontWrapPythonPrograms" "catchConflicts"
  ] // {

  name = namePrefix + name;

  buildInputs = ([ wrapPython (ensureNewerSourcesHook { year = "1980"; }) ]
    ++ (lib.optional (lib.hasSuffix "zip" attrs.src.name or "") unzip)
    ++ lib.optionals doCheck checkInputs
    ++ lib.optional catchConflicts setuptools # If we nog longer propagate setuptools
    ++ buildInputs
    ++ pythonPath
  );

  # Propagate python and setuptools. We should stop propagating setuptools.
  propagatedBuildInputs = propagatedBuildInputs ++ [ python setuptools ];

  # Python packages don't have a checkPhase, only an installCheckPhase
  doCheck = false;
  doInstallCheck = doCheck;

  postFixup = lib.optionalString (!dontWrapPythonPrograms) ''
    wrapPythonPrograms
  '' + lib.optionalString removeBinBytecode ''
    if [ -d "$out/bin" ]; then
      rm -rf "$out/bin/__pycache__"                 # Python 3
      find "$out/bin" -type f -name "*.pyc" -delete # Python 2
    fi
  '' + lib.optionalString catchConflicts ''
    # Check if we have two packages with the same name in the closure and fail.
    # If this happens, something went wrong with the dependencies specs.
    # Intentionally kept in a subdirectory, see catch_conflicts/README.md.
    ${python.interpreter} ${./catch_conflicts}/catch_conflicts.py
  '' + attrs.postFixup or '''';

  meta = {
    # default to python's platforms
    platforms = python.meta.platforms;
    isBuildPythonPackage = python.meta.platforms;
  } // meta;
}))
