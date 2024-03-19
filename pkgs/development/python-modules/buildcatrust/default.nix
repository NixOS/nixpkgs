{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "buildcatrust";
  version = "0.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mjX+T5xo6cD1GxJ49Tx7zthPbGPFPYaf2qcNKVHEzJA=";
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
