{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyglm";
  version = "2.7.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Zuzu-Typ";
    repo = "PyGLM";
    tag = version;
    hash = "sha256-5NXueFZ4+hIP1xd30Dt7sv/oxEqh6ejJoJtQv2rpGyQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "glm" ];

  meta = {
    homepage = "https://github.com/Zuzu-Typ/PyGLM";
    description = "OpenGL Mathematics (GLM) library for Python written in C++";
    changelog = "https://github.com/Zuzu-Typ/PyGLM/releases/tag/${src.tag}";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ sund3RRR ];
  };
}
