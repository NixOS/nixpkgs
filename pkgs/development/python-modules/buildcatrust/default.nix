{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "buildcatrust";
  version = "0.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ac10CZdihFBmr5LE6xFKx4+zr2n5nyR23px6N4vN05M=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Non-hermetic, needs internet access (e.g. attempts to retrieve NSS store).
    "buildcatrust/tests/test_nonhermetic.py"
  ];

  pythonImportsCheck = [
    "buildcatrust"
    "buildcatrust.cli"
  ];

  meta = with lib; {
    description = "Build SSL/TLS trust stores";
    mainProgram = "buildcatrust";
    homepage = "https://github.com/lukegb/buildcatrust";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
  };
}
