# Generic builder.

{ lib
, config
, python
, wrapPython
, unzip
, ensureNewerSourcesForZipFilesHook
# Whether the derivation provides a Python module or not.
, toPythonModule
, namePrefix
, update-python-libraries
, setuptools
, flitBuildHook
, pipBuildHook
, pipInstallHook
, pythonCatchConflictsHook
, pythonImportsCheckHook
, pythonNamespacesHook
, pythonOutputDistHook
, pythonRemoveBinBytecodeHook
, pythonRemoveTestsDirHook
, setuptoolsBuildHook
, setuptoolsCheckHook
, wheelUnpackHook
, eggUnpackHook
, eggBuildHook
, eggInstallHook
}:

{ name ? "${attrs.pname}-${attrs.version}"

# Build-time dependencies for the package
, nativeBuildInputs ? []

# Run-time dependencies for the package
, buildInputs ? []

# Dependencies needed for running the checkPhase.
# These are added to buildInputs when doCheck = true.
, checkInputs ? []
, nativeCheckInputs ? []

# propagate build dependencies so in case we have A -> B -> C,
# C can import package A propagated by B
, propagatedBuildInputs ? []

# DEPRECATED: use propagatedBuildInputs
, pythonPath ? []

# Enabled to detect some (native)BuildInputs mistakes
, strictDeps ? true

, outputs ? [ "out" ]

# used to disable derivation, useful for specific python versions
, disabled ? false

# Raise an error if two packages are installed with the same name
# TODO: For cross we probably need a different PYTHONPATH, or not
# add the runtime deps until after buildPhase.
, catchConflicts ? (python.stdenv.hostPlatform == python.stdenv.buildPlatform)

# Additional arguments to pass to the makeWrapper function, which wraps
# generated binaries.
, makeWrapperArgs ? []

# Skip wrapping of python programs altogether
, dontWrapPythonPrograms ? false

# Don't use Pip to install a wheel
# Note this is actually a variable for the pipInstallPhase in pip's setupHook.
# It's included here to prevent an infinite recursion.
, dontUsePipInstall ? false

# Skip setting the PYTHONNOUSERSITE environment variable in wrapped programs
, permitUserSite ? false

# Remove bytecode from bin folder.
# When a Python script has the extension `.py`, bytecode is generated
# Typically, executables in bin have no extension, so no bytecode is generated.
# However, some packages do provide executables with extensions, and thus bytecode is generated.
, removeBinBytecode ? true

# Several package formats are supported.
# "setuptools" : Install a common setuptools/distutils based package. This builds a wheel.
# "wheel" : Install from a pre-compiled wheel.
# "flit" : Install a flit package. This builds a wheel.
# "pyproject": Install a package using a ``pyproject.toml`` file (PEP517). This builds a wheel.
# "egg": Install a package from an egg.
# "other" : Provide your own buildPhase and installPhase.
, format ? "setuptools"

, meta ? {}

, passthru ? {}

, doCheck ? config.doCheckByDefault or false

, disabledTestPaths ? []

, ... } @ attrs:


# Keep extra attributes from `attrs`, e.g., `patchPhase', etc.
if disabled
then throw "${name} not supported for interpreter ${python.executable}"
else

let
  inherit (python) stdenv;

  withDistOutput = lib.elem format ["pyproject" "setuptools" "flit" "wheel"];

  name_ = name;

  self = toPythonModule (stdenv.mkDerivation ((builtins.removeAttrs attrs [
    "disabled" "checkPhase" "checkInputs" "nativeCheckInputs" "doCheck" "doInstallCheck" "dontWrapPythonPrograms" "catchConflicts" "format"
    "disabledTestPaths" "outputs"
  ]) // {

    name = namePrefix + name_;

    nativeBuildInputs = [
      python
      wrapPython
      ensureNewerSourcesForZipFilesHook  # move to wheel installer (pip) or builder (setuptools, flit, ...)?
      pythonRemoveTestsDirHook
    ] ++ lib.optionals catchConflicts [
      pythonCatchConflictsHook
    ] ++ lib.optionals removeBinBytecode [
      pythonRemoveBinBytecodeHook
    ] ++ lib.optionals (lib.hasSuffix "zip" (attrs.src.name or "")) [
      unzip
    ] ++ lib.optionals (format == "setuptools") [
      setuptoolsBuildHook
    ] ++ lib.optionals (format == "flit") [
      flitBuildHook
    ] ++ lib.optionals (format == "pyproject") [
      pipBuildHook
    ] ++ lib.optionals (format == "wheel") [
      wheelUnpackHook
    ] ++ lib.optionals (format == "egg") [
      eggUnpackHook eggBuildHook eggInstallHook
    ] ++ lib.optionals (!(format == "other") || dontUsePipInstall) [
      pipInstallHook
    ] ++ lib.optionals (stdenv.buildPlatform == stdenv.hostPlatform) [
      # This is a test, however, it should be ran independent of the checkPhase and checkInputs
      pythonImportsCheckHook
    ] ++ lib.optionals (python.pythonAtLeast "3.3") [
      # Optionally enforce PEP420 for python3
      pythonNamespacesHook
    ] ++ lib.optionals withDistOutput [
      pythonOutputDistHook
    ] ++ nativeBuildInputs;

    buildInputs = buildInputs ++ pythonPath;

    propagatedBuildInputs = propagatedBuildInputs ++ [
      # we propagate python even for packages transformed with 'toPythonApplication'
      # this pollutes the PATH but avoids rebuilds
      # see https://github.com/NixOS/nixpkgs/issues/170887 for more context
      python
    ];

    inherit strictDeps;

    LANG = "${if python.stdenv.isDarwin then "en_US" else "C"}.UTF-8";

    # Python packages don't have a checkPhase, only an installCheckPhase
    doCheck = false;
    doInstallCheck = attrs.doCheck or true;
    nativeInstallCheckInputs = [
    ] ++ lib.optionals (format == "setuptools") [
      # Longer-term we should get rid of this and require
      # users of this function to set the `installCheckPhase` or
      # pass in a hook that sets it.
      setuptoolsCheckHook
    ] ++ nativeCheckInputs;
    installCheckInputs = checkInputs;

    postFixup = lib.optionalString (!dontWrapPythonPrograms) ''
      wrapPythonPrograms
    '' + attrs.postFixup or "";

    # Python packages built through cross-compilation are always for the host platform.
    disallowedReferences = lib.optionals (python.stdenv.hostPlatform != python.stdenv.buildPlatform) [ python.pythonForBuild ];

    outputs = outputs ++ lib.optional withDistOutput "dist";

    meta = {
      # default to python's platforms
      platforms = python.meta.platforms;
      isBuildPythonPackage = python.meta.platforms;
    } // meta;
  } // lib.optionalAttrs (attrs?checkPhase) {
    # If given use the specified checkPhase, otherwise use the setup hook.
    # Longer-term we should get rid of `checkPhase` and use `installCheckPhase`.
    installCheckPhase = attrs.checkPhase;
  } //  lib.optionalAttrs (disabledTestPaths != []) {
      disabledTestPaths = lib.escapeShellArgs disabledTestPaths;
  }));

  passthru.updateScript = let
      filename = builtins.head (lib.splitString ":" self.meta.position);
    in attrs.passthru.updateScript or [ update-python-libraries filename ];
in lib.extendDerivation true passthru self
