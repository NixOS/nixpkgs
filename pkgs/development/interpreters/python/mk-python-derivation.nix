# Generic builder.

{
  lib,
  config,
  python,
  wrapPython,
  unzip,
  ensureNewerSourcesForZipFilesHook,
  # Whether the derivation provides a Python module or not.
  toPythonModule,
  namePrefix,
  update-python-libraries,
  setuptools,
  pypaBuildHook,
  pypaInstallHook,
  pythonCatchConflictsHook,
  pythonImportsCheckHook,
  pythonNamespacesHook,
  pythonOutputDistHook,
  pythonRelaxDepsHook,
  pythonRemoveBinBytecodeHook,
  pythonRemoveTestsDirHook,
  pythonRuntimeDepsCheckHook,
  setuptoolsBuildHook,
  wheelUnpackHook,
  eggUnpackHook,
  eggBuildHook,
  eggInstallHook,
}:

let
  inherit (builtins) unsafeGetAttrPos;
  inherit (lib)
    elem
    extendDerivation
    fixedWidthString
    flip
    getName
    hasSuffix
    head
    isBool
    max
    optional
    optionalAttrs
    optionals
    optionalString
    removePrefix
    splitString
    stringLength
    ;

  leftPadName =
    name: against:
    let
      len = max (stringLength name) (stringLength against);
    in
    fixedWidthString len " " name;

  isPythonModule =
    drv:
    # all pythonModules have the pythonModule attribute
    (drv ? "pythonModule")
    # Some pythonModules are turned in to a pythonApplication by setting the field to false
    && (!isBool drv.pythonModule);

  isMismatchedPython = drv: drv.pythonModule != python;

  withDistOutput' = flip elem [
    "pyproject"
    "setuptools"
    "wheel"
  ];

  isBootstrapInstallPackage' = flip elem [
    "flit-core"
    "installer"
  ];

  isBootstrapPackage' = flip elem (
    [
      "build"
      "packaging"
      "pyproject-hooks"
      "wheel"
    ]
    ++ optionals (python.pythonOlder "3.11") [
      "tomli"
    ]
  );

  isSetuptoolsDependency' = flip elem [
    "setuptools"
    "wheel"
  ];

  cleanAttrs = flip removeAttrs [
    "disabled"
    "checkPhase"
    "checkInputs"
    "nativeCheckInputs"
    "doCheck"
    "doInstallCheck"
    "pyproject"
    "format"
    "disabledTestPaths"
    "disabledTests"
    "pytestFlags"
    "pytestFlagsArray"
    "unittestFlags"
    "unittestFlagsArray"
    "outputs"
    "stdenv"
    "dependencies"
    "optional-dependencies"
    "build-system"
  ];

in

{
  # Build-time dependencies for the package
  nativeBuildInputs ? [ ],

  # Run-time dependencies for the package
  buildInputs ? [ ],

  # Dependencies needed for running the checkPhase.
  # These are added to buildInputs when doCheck = true.
  checkInputs ? [ ],
  nativeCheckInputs ? [ ],

  # propagate build dependencies so in case we have A -> B -> C,
  # C can import package A propagated by B
  propagatedBuildInputs ? [ ],

  # Python module dependencies.
  # These are named after PEP-621.
  dependencies ? [ ],
  optional-dependencies ? { },

  # Python PEP-517 build systems.
  build-system ? [ ],

  # DEPRECATED: use propagatedBuildInputs
  pythonPath ? [ ],

  # Enabled to detect some (native)BuildInputs mistakes
  strictDeps ? true,

  outputs ? [ "out" ],

  # used to disable derivation, useful for specific python versions
  disabled ? false,

  # Raise an error if two packages are installed with the same name
  # TODO: For cross we probably need a different PYTHONPATH, or not
  # add the runtime deps until after buildPhase.
  catchConflicts ? (python.stdenv.hostPlatform == python.stdenv.buildPlatform),

  # Additional arguments to pass to the makeWrapper function, which wraps
  # generated binaries.
  makeWrapperArgs ? [ ],

  # Skip wrapping of python programs altogether
  dontWrapPythonPrograms ? false,

  # Don't use Pip to install a wheel
  # Note this is actually a variable for the pipInstallPhase in pip's setupHook.
  # It's included here to prevent an infinite recursion.
  dontUsePipInstall ? false,

  # Skip setting the PYTHONNOUSERSITE environment variable in wrapped programs
  permitUserSite ? false,

  # Remove bytecode from bin folder.
  # When a Python script has the extension `.py`, bytecode is generated
  # Typically, executables in bin have no extension, so no bytecode is generated.
  # However, some packages do provide executables with extensions, and thus bytecode is generated.
  removeBinBytecode ? true,

  # pyproject = true <-> format = "pyproject"
  # pyproject = false <-> format = "other"
  # https://github.com/NixOS/nixpkgs/issues/253154
  pyproject ? null,

  # Several package formats are supported.
  # "setuptools" : Install a common setuptools/distutils based package. This builds a wheel.
  # "wheel" : Install from a pre-compiled wheel.
  # "pyproject": Install a package using a ``pyproject.toml`` file (PEP517). This builds a wheel.
  # "egg": Install a package from an egg.
  # "other" : Provide your own buildPhase and installPhase.
  format ? null,

  meta ? { },

  doCheck ? true,

  disabledTestPaths ? [ ],

  # Allow passing in a custom stdenv to buildPython*
  stdenv ? python.stdenv,

  ...
}@attrs:

let
  # Keep extra attributes from `attrs`, e.g., `patchPhase', etc.
  self = stdenv.mkDerivation (
    finalAttrs:
    let
      format' =
        assert (pyproject != null) -> (format == null);
        if pyproject != null then
          if pyproject then "pyproject" else "other"
        else if format != null then
          format
        else
          "setuptools";

      withDistOutput = withDistOutput' format';

      validatePythonMatches =
        let
          throwMismatch =
            attrName: drv:
            let
              myName = "'${finalAttrs.name}'";
              theirName = "'${drv.name}'";
              optionalLocation =
                let
                  pos = unsafeGetAttrPos (if attrs ? "pname" then "pname" else "name") attrs;
                in
                optionalString (pos != null) " at ${pos.file}:${toString pos.line}:${toString pos.column}";
            in
            throw ''
              Python version mismatch in ${myName}:

              The Python derivation ${myName} depends on a Python derivation
              named ${theirName}, but the two derivations use different versions
              of Python:

                  ${leftPadName myName theirName} uses ${python}
                  ${leftPadName theirName myName} uses ${toString drv.pythonModule}

              Possible solutions:

                * If ${theirName} is a Python library, change the reference to ${theirName}
                  in the ${attrName} of ${myName} to use a ${theirName} built from the same
                  version of Python

                * If ${theirName} is used as a tool during the build, move the reference to
                  ${theirName} in ${myName} from ${attrName} to nativeBuildInputs

                * If ${theirName} provides executables that are called at run time, pass its
                  bin path to makeWrapperArgs:

                      makeWrapperArgs = [ "--prefix PATH : ''${lib.makeBinPath [ ${getName drv} ] }" ];

              ${optionalLocation}
            '';

          checkDrv =
            attrName: drv:
            if (isPythonModule drv) && (isMismatchedPython drv) then throwMismatch attrName drv else drv;

        in
        attrName: inputs: map (checkDrv attrName) inputs;

      isBootstrapInstallPackage = isBootstrapInstallPackage' (attrs.pname or null);

      isBootstrapPackage = isBootstrapInstallPackage || isBootstrapPackage' (attrs.pname or null);

      isSetuptoolsDependency = isSetuptoolsDependency' (attrs.pname or null);

    in
    (cleanAttrs attrs)
    // {

      name = namePrefix + attrs.name or "${finalAttrs.pname}-${finalAttrs.version}";

      inherit catchConflicts;

      nativeBuildInputs =
        [
          python
          wrapPython
          ensureNewerSourcesForZipFilesHook # move to wheel installer (pip) or builder (setuptools, flit, ...)?
          pythonRemoveTestsDirHook
        ]
        ++ optionals (finalAttrs.catchConflicts && !isBootstrapPackage && !isSetuptoolsDependency) [
          #
          # 1. When building a package that is also part of the bootstrap chain, we
          #    must ignore conflicts after installation, because there will be one with
          #    the package in the bootstrap.
          #
          # 2. When a package is a dependency of setuptools, we must ignore conflicts
          #    because the hook that checks for conflicts uses setuptools.
          #
          pythonCatchConflictsHook
        ]
        ++ optionals (attrs ? pythonRelaxDeps || attrs ? pythonRemoveDeps) [
          pythonRelaxDepsHook
        ]
        ++ optionals removeBinBytecode [
          pythonRemoveBinBytecodeHook
        ]
        ++ optionals (hasSuffix "zip" (attrs.src.name or "")) [
          unzip
        ]
        ++ optionals (format' == "setuptools") [
          setuptoolsBuildHook
        ]
        ++ optionals (format' == "pyproject") [
          (
            if isBootstrapPackage then
              pypaBuildHook.override {
                inherit (python.pythonOnBuildForHost.pkgs.bootstrap) build;
                wheel = null;
              }
            else
              pypaBuildHook
          )
          (
            if isBootstrapPackage then
              pythonRuntimeDepsCheckHook.override {
                inherit (python.pythonOnBuildForHost.pkgs.bootstrap) packaging;
              }
            else
              pythonRuntimeDepsCheckHook
          )
        ]
        ++ optionals (format' == "wheel") [
          wheelUnpackHook
        ]
        ++ optionals (format' == "egg") [
          eggUnpackHook
          eggBuildHook
          eggInstallHook
        ]
        ++ optionals (format' != "other") [
          (
            if isBootstrapInstallPackage then
              pypaInstallHook.override {
                inherit (python.pythonOnBuildForHost.pkgs.bootstrap) installer;
              }
            else
              pypaInstallHook
          )
        ]
        ++ optionals (stdenv.buildPlatform == stdenv.hostPlatform) [
          # This is a test, however, it should be ran independent of the checkPhase and checkInputs
          pythonImportsCheckHook
        ]
        ++ optionals (python.pythonAtLeast "3.3") [
          # Optionally enforce PEP420 for python3
          pythonNamespacesHook
        ]
        ++ optionals withDistOutput [
          pythonOutputDistHook
        ]
        ++ nativeBuildInputs
        ++ build-system;

      buildInputs = validatePythonMatches "buildInputs" (buildInputs ++ pythonPath);

      propagatedBuildInputs = validatePythonMatches "propagatedBuildInputs" (
        propagatedBuildInputs
        ++ dependencies
        ++ [
          # we propagate python even for packages transformed with 'toPythonApplication'
          # this pollutes the PATH but avoids rebuilds
          # see https://github.com/NixOS/nixpkgs/issues/170887 for more context
          python
        ]
      );

      inherit strictDeps;

      LANG = "${if python.stdenv.hostPlatform.isDarwin then "en_US" else "C"}.UTF-8";

      # Python packages don't have a checkPhase, only an installCheckPhase
      doCheck = false;
      doInstallCheck = attrs.doCheck or true;
      nativeInstallCheckInputs = nativeCheckInputs;
      installCheckInputs = checkInputs;

      inherit dontWrapPythonPrograms;

      postFixup =
        optionalString (!finalAttrs.dontWrapPythonPrograms) ''
          wrapPythonPrograms
        ''
        + attrs.postFixup or "";

      # Python packages built through cross-compilation are always for the host platform.
      disallowedReferences = optionals (python.stdenv.hostPlatform != python.stdenv.buildPlatform) [
        python.pythonOnBuildForHost
      ];

      outputs = outputs ++ optional withDistOutput "dist";

      passthru =
        {
          inherit disabled;
        }
        // {
          updateScript =
            let
              filename = head (splitString ":" finalAttrs.finalPackage.meta.position);
            in
            [
              update-python-libraries
              filename
            ];
        }
        // optionalAttrs (dependencies != [ ]) {
          inherit dependencies;
        }
        // optionalAttrs (optional-dependencies != { }) {
          inherit optional-dependencies;
        }
        // optionalAttrs (build-system != [ ]) {
          inherit build-system;
        }
        // attrs.passthru or { };

      meta = {
        # default to python's platforms
        platforms = python.meta.platforms;
        isBuildPythonPackage = python.meta.platforms;
      } // meta;
    }
    // optionalAttrs (attrs ? checkPhase) {
      # If given use the specified checkPhase, otherwise use the setup hook.
      # Longer-term we should get rid of `checkPhase` and use `installCheckPhase`.
      installCheckPhase = attrs.checkPhase;
    }
    // optionalAttrs (attrs.doCheck or true) (
      optionalAttrs (disabledTestPaths != [ ]) {
        disabledTestPaths = disabledTestPaths;
      }
      // optionalAttrs (attrs ? disabledTests) {
        disabledTests = attrs.disabledTests;
      }
      // optionalAttrs (attrs ? pytestFlags) {
        pytestFlags = attrs.pytestFlags;
      }
      // optionalAttrs (attrs ? pytestFlagsArray) {
        pytestFlagsArray = attrs.pytestFlagsArray;
      }
      // optionalAttrs (attrs ? unittestFlags) {
        unittestFlags = attrs.unittestFlags;
      }
      // optionalAttrs (attrs ? unittestFlagsArray) {
        unittestFlagsArray = attrs.unittestFlagsArray;
      }
    )
  );

  # This derivation transformation function must be independent to `attrs`
  # for fixed-point arguments support in the future.
  transformDrv =
    drv:
    extendDerivation (
      drv.disabled
      -> throw "${removePrefix namePrefix drv.name} not supported for interpreter ${python.executable}"
    ) { } (toPythonModule drv);

in
transformDrv self
