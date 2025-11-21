{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,

  # tests
  pytestCheckHook,
  wcag-contrast-ratio,
  pythonOlder,
}:

let
  pygments = buildPythonPackage rec {
    pname = "pygments";
    version = "2.19.2";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-Y2yyR3zsf4lSU2lwvFM7xDdDVC9wOSrgJjdGAK3VuIc=";
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

    meta = {
      changelog = "https://github.com/pygments/pygments/releases/tag/${version}";
      homepage = "https://pygments.org/";
      description = "Generic syntax highlighter";
      mainProgram = "pygmentize";
      license = lib.licenses.bsd2;
      maintainers = with lib.maintainers; [
        sigmanificient
        ryand56
      ];
    };
  };
in
pygments
