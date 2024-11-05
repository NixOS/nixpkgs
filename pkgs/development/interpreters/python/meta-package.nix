{
  buildPythonPackage,
  lib,
  hatchling,
}:
{
  pname,
  version,
  dependencies ? [ ],
  optional-dependencies ? { },
  passthru ? { },
  meta ? { },
}:

# Create a "fake" meta package to satisfy a dependency on a package, but don't actually build it.
# This is useful for packages that have a split binary/source dichotomy like psycopg2/psycopg2-binary,
# where we want to use the former, but some projects declare a dependency on the latter.

buildPythonPackage {
  inherit
    pname
    version
    dependencies
    optional-dependencies
    meta
    passthru
    ;

  pyproject = true;

  # Make a minimal pyproject.toml that can be built
  unpackPhase = ''
    cat > pyproject.toml << EOF
    [project]
    name = "${pname}"
    version = "${version}"
    dependencies = ${builtins.toJSON (map lib.getName dependencies)}

    [project.optional-dependencies]
    ${lib.optionalString (optional-dependencies != { }) (
      (lib.concatStringsSep "\n" (
        lib.mapAttrsToList (
          group: deps: group + " = " + builtins.toJSON (map lib.getName deps)
        ) optional-dependencies
      ))
    )}

    [tool.hatch.build.targets.wheel]
    bypass-selection = true

    [build-system]
    requires = ["hatchling"]
    build-backend = "hatchling.build"
    EOF
  '';

  build-system = [ hatchling ];
}
