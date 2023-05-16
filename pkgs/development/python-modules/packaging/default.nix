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
<<<<<<< HEAD
    version = "23.1";
=======
    version = "23.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    format = "pyproject";

    disabled = pythonOlder "3.7";

    src = fetchPypi {
      inherit pname version;
<<<<<<< HEAD
      hash = "sha256-o5KYDSts/6ZEQxiYvlSwBFFRMZ0efsNPDP7Uh2fdM08=";
=======
      hash = "sha256-tq0pf4kH3g+i/hzL0m/a84f19Hxydf7fjM6J+ZRGz5c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      maintainers = with maintainers; [ bennofs ];
=======
      maintainers = with maintainers; [ bennofs SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };
in
packaging
