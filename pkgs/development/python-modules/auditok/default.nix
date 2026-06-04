{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  matplotlib,
  numpy,
  pyaudio,
  pydub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "auditok";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "amsehili";
    repo = "auditok";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hSFHozTx2ygb2VdIYB8mw0RIMUVJ3Lo0mdHXPZasYGA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    matplotlib
    numpy
    pyaudio
    pydub
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # flaky: matplotlib pixel-equality drift
    "tests/test_plotting.py"
  ];

  pythonImportsCheck = [ "auditok" ];

  # The most recent version is 0.2.0, but the only dependent package is
  # ffsubsync, which is pinned at 0.1.5.
  passthru.skipBulkUpdate = true;

  meta = {
    description = "Audio Activity Detection tool that can process online data as well as audio files";
    mainProgram = "auditok";
    homepage = "https://github.com/amsehili/auditok/";
    changelog = "https://github.com/amsehili/auditok/blob/v${finalAttrs.version}/CHANGELOG";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
