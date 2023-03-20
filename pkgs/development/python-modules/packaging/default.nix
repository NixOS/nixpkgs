{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, pretend
, pytestCheckHook
, pythonOlder
}:

let
  packaging = buildPythonPackage rec {
    pname = "packaging";
    version = "23.0";
    format = "pyproject";

    disabled = pythonOlder "3.7";

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-tq0pf4kH3g+i/hzL0m/a84f19Hxydf7fjM6J+ZRGz5c=";
    };

    nativeBuildInputs = [
      flit-core
    ];

    nativeCheckInputs = [
      pytestCheckHook
      pretend
    ];

    # Prevent circular dependency with pytest
    doCheck = false;

    pythonImportsCheck = [ "packaging" ];

    passthru.tests = packaging.overridePythonAttrs (_: { doCheck = true; });

    meta = with lib; {
      description = "Core utilities for Python packages";
      homepage = "https://github.com/pypa/packaging";
      license = with licenses; [ bsd2 asl20 ];
      maintainers = with maintainers; [ bennofs SuperSandro2000 ];
    };
  };
in
packaging
