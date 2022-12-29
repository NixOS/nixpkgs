{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, pyparsing
, pytestCheckHook
, pythonOlder
, pretend
}:

let
  packaging = buildPythonPackage rec {
    pname = "packaging";
    version = "22.0";
    format = "pyproject";

    disabled = pythonOlder "3.6";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-IZjsIL1MAXuPlxfgDwyHFAdvwv2TgWdQq0jixB3iz9M=";
    };

    nativeBuildInputs = [
      flit-core
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
