{ lib
, buildPythonPackage
, fetchPypi
, pyparsing
, pytestCheckHook
, pythonOlder
, pretend
, setuptools
}:

let
  packaging = buildPythonPackage rec {
    pname = "packaging";
    version = "21.3";
    format = "pyproject";

    disabled = pythonOlder "3.6";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-3UfEKSfYmrkR5gZRiQfMLTofOLvQJjhZcGQ/nFuOz+s=";
    };

    nativeBuildInputs = [
      setuptools
    ];

    propagatedBuildInputs = [ pyparsing ];

    checkInputs = [
      pytestCheckHook
      pretend
    ];

    # Prevent circular dependency
    doCheck = false;

    passthru.tests = packaging.overridePythonAttrs (_: { doCheck = true; });

    meta = with lib; {
      description = "Core utilities for Python packages";
      homepage = "https://github.com/pypa/packaging";
      license = with licenses; [ bsd2 asl20 ];
      maintainers = with maintainers; [ bennofs ];
    };
  };
in
packaging
