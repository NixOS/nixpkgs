{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyglm";
  version = "2.8.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Zuzu-Typ";
    repo = "PyGLM";
    tag = finalAttrs.version;
    hash = "sha256-7IN/kqFCwAMeVUrBB/CfCm9bSt1dHMbbLtqVInRFCk0=";
    fetchSubmodules = true;
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Having the source root in `sys.path` causes import issues
  preCheck = ''
    cd test
  '';

  pythonImportsCheck = [
    "pyglm"
    "glm"
  ];

  meta = {
    homepage = "https://github.com/Zuzu-Typ/PyGLM";
    description = "OpenGL Mathematics (GLM) library for Python written in C++";
    changelog = "https://github.com/Zuzu-Typ/PyGLM/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ sund3RRR ];
  };
})
