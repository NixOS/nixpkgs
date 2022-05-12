{ lib
, buildPythonPackage
, fetchPypi
, docutils
, lxml
, pytestCheckHook
, wcag-contrast-ratio
}:

let pygments = buildPythonPackage
  rec {
    pname = "pygments";
    version = "2.12.0";

    src = fetchPypi {
      pname = "Pygments";
      inherit version;
      sha256 = "sha256-XrEWEY+WEv8e6JrJZDe7a0no8E2KE7UUuib2ICCOJus=";
    };

    propagatedBuildInputs = [
      docutils
    ];

    # circular dependencies if enabled by default
    doCheck = false;
    checkInputs = [
      lxml
      pytestCheckHook
      wcag-contrast-ratio
    ];

    disabledTestPaths = [
      # 5 lines diff, including one nix store path in 20000+ lines
      "tests/examplefiles/bash/ltmain.sh"
    ];

    pythonImportsCheck = [ "pygments" ];

    passthru.tests = {
      check = pygments.overridePythonAttrs (_: { doCheck = true; });
    };

    meta = with lib; {
      homepage = "https://pygments.org/";
      description = "A generic syntax highlighter";
      license = licenses.bsd2;
      maintainers = with maintainers; [ SuperSandro2000 ];
    };
  };
in pygments
