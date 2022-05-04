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
    version = "2.11.2";

    src = fetchPypi {
      pname = "Pygments";
      inherit version;
      sha256 = "4e426f72023d88d03b2fa258de560726ce890ff3b630f88c21cbb8b2503b8c6a";
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
