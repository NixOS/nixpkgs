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
  pygments = buildPythonPackage rec {
    pname = "pygments";
    version = "2.17.2";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-2kbOyf0t5b46inhPQ05MSrZwtP9U1gXEwnF+nUnEw2c=";
    };

    nativeBuildInputs = [ hatchling ];

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

    meta = with lib; {
      changelog = "https://github.com/pygments/pygments/releases/tag/${version}";
      homepage = "https://pygments.org/";
      description = "Generic syntax highlighter";
      mainProgram = "pygmentize";
      license = licenses.bsd2;
      maintainers = with maintainers; [ ];
    };
  };
in
pygments
