{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,

  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "amplitude-analytics";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "amplitude";
    repo = "Amplitude-Python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KX0XTQK09S3pJfHp89V4CQQi3U5NxHSl+8Wy8ZLM670=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "amplitude" ];

  meta = {
    description = "Official Amplitude backend Python SDK for server-side instrumentation";
    homepage = "https://github.com/amplitude/Amplitude-Python";
    downloadPage = "https://github.com/amplitude/Amplitude-Python/releases";
    changelog = "https://github.com/amplitude/Amplitude-Python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prince213 ];
  };
})
