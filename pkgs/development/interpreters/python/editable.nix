{
  buildPythonPackage,
  lib,
  hatchling,
  tomli-w,
}:
{
  pname,
  version,

  # Editable root as string.
  # Environment variables will be expanded at runtime using os.path.expandvars.
  root,

  # Arguments passed on verbatim to buildPythonPackage
  derivationArgs ? { },

  # Python dependencies
  dependencies ? [ ],
  optional-dependencies ? { },

  # PEP-518 build-system https://peps.python.org/pep-518
  build-system ? [ ],

  # PEP-621 entry points https://peps.python.org/pep-0621/#entry-points
  scripts ? { },
  gui-scripts ? { },
  entry-points ? { },

  passthru ? { },
  meta ? { },
}:

# Create a PEP-660 (https://peps.python.org/pep-0660/) editable package pointing to an impure location outside the Nix store.
# The primary use case of this function is to enable local development workflows where the local package is installed into a virtualenv-like environment using withPackages.

assert lib.isString root;
let
  # In editable mode build-system's are considered to be runtime dependencies.
  dependencies' = dependencies ++ build-system;

  pyproject = {
    # PEP-621 project table
    project = {
      name = pname;
      inherit
        version
        scripts
        gui-scripts
        entry-points
        ;
      dependencies = map lib.getName dependencies';
      optional-dependencies = lib.mapAttrs (_: map lib.getName) optional-dependencies;
    };

    # Allow empty package
    tool.hatch.build.targets.wheel.bypass-selection = true;

    # Include our editable pointer file in build
    tool.hatch.build.targets.wheel.force-include."_${pname}.pth" = "_${pname}.pth";

    # Build editable package using hatchling
    build-system = {
      requires = [ "hatchling" ];
      build-backend = "hatchling.build";
    };
  };

in
buildPythonPackage (
  {
    inherit
      pname
      version
      optional-dependencies
      passthru
      meta
      ;
    dependencies = dependencies';

    pyproject = true;

    unpackPhase = ''
      python -c "import json, tomli_w; print(tomli_w.dumps(json.load(open('$pyprojectContentsPath'))))" > pyproject.toml
      echo 'import os.path, sys; sys.path.insert(0, os.path.expandvars("${root}"))' > _${pname}.pth
    '';

    build-system = [ hatchling ];
  }
  // derivationArgs
  // {
    # Note: Using formats.toml generates another intermediary derivation that needs to be built.
    # We inline the same functionality for better UX.
    nativeBuildInputs = (derivationArgs.nativeBuildInputs or [ ]) ++ [ tomli-w ];
    pyprojectContents = builtins.toJSON pyproject;
    passAsFile = [ "pyprojectContents" ];

  }
)
