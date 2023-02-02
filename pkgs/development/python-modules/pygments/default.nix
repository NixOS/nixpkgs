{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, lxml
, pytestCheckHook
, wcag-contrast-ratio
}:

let pygments = buildPythonPackage
  rec {
    pname = "pygments";
    version = "2.14.0";
    format = "pyproject";

    src = fetchPypi {
      pname = "Pygments";
      inherit version;
      hash = "sha256-s+0GqeismpquWm9dvniopYZV0XtDuTwHjwlN3Edq4pc=";
    };

    nativeBuildInputs = [
      setuptools
    ];

    # circular dependencies if enabled by default
    doCheck = false;

    nativeCheckInputs = [
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
