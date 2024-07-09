{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,

  # tests
  pytestCheckHook,
  wcag-contrast-ratio,
  pythonOlder
}:

let
  pygments = buildPythonPackage rec {
    pname = "pygments";
    version = "2.18.0";
    pyproject = true;

    disabled = pythonOlder "3.8"; # 2.18.0 requirement

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-eG/4AvMukTEb/ziJ9umoboFQX+mfJzW7bWCuDFAE8Zk=";
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
      maintainers = with maintainers; [ sigmanificient ];
    };
  };
in
pygments
