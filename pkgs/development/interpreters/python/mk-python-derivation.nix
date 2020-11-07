# Generic builder.

{ lib
, config
, python
, wrapPython
, unzip
, ensureNewerSourcesForZipFilesHook
# Whether the derivation provides a Python module or not.
, toPythonModule
, computeRequiredPythonModules
, namePrefix
, update-python-libraries
, setuptools
, flitBuildHook
, pipBuildHook
, pipInstallHook
, pythonCatchConflictsHook
, pythonImportsCheckHook
, pythonNamespacesHook
, pythonRecompileBytecodeHook
, pythonRemoveBinBytecodeHook
, pythonRemoveTestsDirHook
, pythonWriteRequiredPythonModulesHook
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

# propagate build dependencies so in case we have A -> B -> C,
# C can import package A propagated by B
, propagatedBuildInputs ? []

# Required Python modules
, requiredPythonModules ? []

# Enabled to detect some (native)BuildInputs mistakes
, strictDeps ? true

# used to disable derivation, useful for specific python versions
, disabled ? false

# Raise an error if two packages are installed with the same name
, catchConflicts ? true

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

, ... } @ attrs:


# Keep extra attributes from `attrs`, e.g., `patchPhase', etc.
if disabled
then throw "${name} not supported for interpreter ${python.executable}"
else

let
  inherit (python) stdenv;

  name_ = namePrefix + name;

  # We've converted from `propagatedBuildInputs` to `requiredPythonModules`.
  # This will cause packages that did not convert to fail at run-time.
  # Here we warn in case Python modules are being propagated.
  # Propagating Python modules is in principle fine, it is however unlikely one
  # would actually want to do that.
  # This is to be released in nixos-21.03 and should thus be removed in nixos-21.09.
  partitionedPropagatedInputs = lib.lists.partition (x: lib.hasAttr "pythonModule" x) (lib.filter (x: x != null) propagatedBuildInputs);
  propagatedPythonInputs = if lib.length partitionedPropagatedInputs.right > 0
    then
      lib.warn ''
        ${name}: Using `propagatedBuildInputs` for Python modules has been deprecated, please use `requiredPythonModules` instead.
        
        Your code may need to look like:

          requiredPythonModules = [ ${lib.concatMapStringsSep " " (drv: drv.pname or drv.name) partitionedPropagatedInputs.right} ];

          propagatedBuildInputs = [ ${lib.concatMapStringsSep " " (drv: drv.pname or drv.name) partitionedPropagatedInputs.wrong} ];

        Note the exact attribute names may be incorrect. Not resolving this issue may result in incorrect wrappers.

        For more information, see https://github.com/NixOS/nixpkgs/pull/102613.
      '' partitionedPropagatedInputs.right
    else
      [ ];
  propagatedDerivationInputs = partitionedPropagatedInputs.wrong;

  requiredPythonModules_ = computeRequiredPythonModules (requiredPythonModules ++ propagatedPythonInputs);

  self = toPythonModule (stdenv.mkDerivation ((builtins.removeAttrs attrs [
    "disabled" "checkPhase" "checkInputs" "doCheck" "doInstallCheck" "dontWrapPythonPrograms" "catchConflicts" "format" "requiredPythonModules"
  ]) // {

    name = name_;   

    nativeBuildInputs = [
      python
      wrapPython
      ensureNewerSourcesForZipFilesHook  # move to wheel installer (pip) or builder (setuptools, flit, ...)?
      pythonRecompileBytecodeHook  # Remove when solved https://github.com/NixOS/nixpkgs/issues/81441
      pythonRemoveTestsDirHook
      pythonWriteRequiredPythonModulesHook
    ] ++ lib.optionals catchConflicts [
      setuptools pythonCatchConflictsHook
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
    ] ++ nativeBuildInputs;

    inherit buildInputs;

    # TODO: stop propagating Python and its packages?
    # Python applications should not propagate Python with its dependencies.
    # In principle, buildPythonApplication could stop using `propagatedBuildInputs`,
    # however, it won't help in case `buildPythonPackage` is used with `toPythonApplication`.
    # Note also, propagation is needed for e.g. `checkInputs` to find its dependencies.
    #
    # Probably the solution is to keep using propagation in case packages,
    # and convert `buildPythonApplication` to first build the package, and then an environment
    # using `python.buildEnv` https://github.com/NixOS/nixpkgs/pull/16672.
    propagatedBuildInputs = propagatedDerivationInputs ++ requiredPythonModules_;

    # requiredPythonModules is also set
    requiredPythonModules = requiredPythonModules_;

    inherit strictDeps;

    LANG = "${if python.stdenv.isDarwin then "en_US" else "C"}.UTF-8";

    # Python packages don't have a checkPhase, only an installCheckPhase
    doCheck = false;
    doInstallCheck = attrs.doCheck or true;
    installCheckInputs = [
    ] ++ lib.optionals (format == "setuptools") [
      # Longer-term we should get rid of this and require
      # users of this function to set the `installCheckPhase` or
      # pass in a hook that sets it.
      setuptoolsCheckHook
    ] ++ checkInputs;

    postFixup = lib.optionalString (!dontWrapPythonPrograms) ''
      wrapPythonPrograms
    '' + attrs.postFixup or '''';

    # Python packages built through cross-compilation are always for the host platform.
    disallowedReferences = lib.optionals (python.stdenv.hostPlatform != python.stdenv.buildPlatform) [ python.pythonForBuild ];

    # For now, revert recompilation of bytecode.
    dontUsePythonRecompileBytecode = true;

    meta = {
      # default to python's platforms
      platforms = python.meta.platforms;
      isBuildPythonPackage = python.meta.platforms;
    } // meta;
  } // lib.optionalAttrs (attrs?checkPhase) {
    # If given use the specified checkPhase, otherwise use the setup hook.
    # Longer-term we should get rid of `checkPhase` and use `installCheckPhase`.
    installCheckPhase = attrs.checkPhase;
  }));

  passthru.updateScript = let
      filename = builtins.head (lib.splitString ":" self.meta.position);
    in attrs.passthru.updateScript or [ update-python-libraries filename ];
in lib.extendDerivation true passthru self
