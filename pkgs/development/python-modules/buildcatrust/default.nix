{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "buildcatrust";
  version = "0.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GYw/RN1OK5fqo3em8hia2l/IwN76hnPnFuYprqeX144=";
  };

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Non-hermetic, needs internet access (e.g. attempts to retrieve NSS store).
    "buildcatrust/tests/test_nonhermetic.py"
  ];

  pythonImportsCheck = [
    "buildcatrust"
    "buildcatrust.cli"
  ];

<<<<<<< HEAD
  meta = {
    description = "Build SSL/TLS trust stores";
    mainProgram = "buildcatrust";
    homepage = "https://github.com/lukegb/buildcatrust";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukegb ];
=======
  meta = with lib; {
    description = "Build SSL/TLS trust stores";
    mainProgram = "buildcatrust";
    homepage = "https://github.com/lukegb/buildcatrust";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
