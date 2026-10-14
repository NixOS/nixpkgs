{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,

  # tests
  pytestCheckHook,
  wcag-contrast-ratio,
}:

let
  pygments = buildPythonPackage (finalAttrs: {
    pname = "pygments";
    version = "2.20.0";
    pyproject = true;

    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-Z1fNA3aAU/+Z8wOcGjbWwKoLJjQ4/KsXUgswowOoK18=";
    };

    build-system = [ hatchling ];

    # circular dependencies if enabled by default
    doCheck = false;

    nativeCheckInputs = [
      pytestCheckHook
      wcag-contrast-ratio
    ];

    disabledTestPaths = [
      # 5 lines diff, including one nix store path in 20000+ lines
      "tests/examplefiles/bash/ltmain.sh"
    ];

    pythonImportsCheck = [ "pygments" ];

    passthru.tests = {
      check = pygments.overridePythonAttrs (_: {
        doCheck = true;
      });
    };

    meta = {
      changelog = "https://github.com/pygments/pygments/releases/tag/${finalAttrs.version}";
      homepage = "https://pygments.org/";
      description = "Generic syntax highlighter";
      mainProgram = "pygmentize";
      license = lib.licenses.bsd2;
      maintainers = with lib.maintainers; [
        sigmanificient
        ryand56
      ];
    };
  });
in
pygments
