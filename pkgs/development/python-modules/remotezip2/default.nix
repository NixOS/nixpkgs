{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  python,
  requests-mock,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "remotezip2";
  version = "0.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "doronz88";
    repo = "python-remotezip2";
    tag = "v${version}";
    hash = "sha256-UyfAoe9pXCGLGPIE2LSLvnIaju+nXt3s7ddGlpmJGUg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonImportsCheck = [ "remotezip2" ];

  nativeCheckInputs = [
    requests-mock
  ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} test_remotezip2.py

    runHook postCheck
  '';

  meta = {
    changelog = "https://github.com/doronz88/python-remotezip2/releases/tag/${src.tag}";
    description = "Access zip file content hosted remotely without downloading the full file";
    homepage = "https://github.com/doronz88/python-remotezip2";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
