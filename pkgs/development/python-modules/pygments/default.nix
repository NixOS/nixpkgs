{ lib
, buildPythonPackage
, fetchPypi

# build-system
, setuptools

# tests
, pytestCheckHook
, wcag-contrast-ratio
}:

let pygments = buildPythonPackage
  rec {
    pname = "pygments";
    version = "2.15.1";
    format = "pyproject";

    src = fetchPypi {
      pname = "Pygments";
      inherit version;
      hash = "sha256-is5NPB3UgYlLIAX1YOrQ+fGe5k/pgzZr4aIeFx0Sd1w=";
    };

    nativeBuildInputs = [
      setuptools
    ];

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

    pythonImportsCheck = [
      "pygments"
    ];

    passthru.tests = {
      check = pygments.overridePythonAttrs (_: { doCheck = true; });
    };

    meta = with lib; {
      changelog = "https://github.com/pygments/pygments/releases/tag/${version}";
      homepage = "https://pygments.org/";
      description = "A generic syntax highlighter";
      mainProgram = "pygmentize";
      license = licenses.bsd2;
      maintainers = with maintainers; [ ];
    };
  };
in pygments
