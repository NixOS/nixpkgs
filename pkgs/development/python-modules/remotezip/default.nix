{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  pytestCheckHook,
  requests-mock,
}:

buildPythonPackage (finalAttrs: {
  pname = "remotezip";
  version = "0.12.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gtsystem";
    repo = "python-remotezip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qItxfjzOc0nulqVRnwrE3JGpML2m/sVyKLtKDbLlJkc=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "remotezip" ];

  meta = {
    description = "Python module to access single members of a zip archive without downloading the full content";
    mainProgram = "remotezip";
    homepage = "https://github.com/gtsystem/python-remotezip";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
