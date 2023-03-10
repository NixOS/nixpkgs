{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "buildcatrust";
  version = "0.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256:0s0m0fy943dakw9cbd40h46qmrhhgrcp292kppyb34m6y27sbagy";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];
  disabledTestPaths = [
    # Non-hermetic, needs internet access (e.g. attempts to retrieve NSS store).
    "buildcatrust/tests/test_nonhermetic.py"
  ];

  pythonImportsCheck = [ "buildcatrust" "buildcatrust.cli" ];

  meta = with lib; {
    description = "Build SSL/TLS trust stores";
    homepage = "https://github.com/lukegb/buildcatrust";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
  };
}
