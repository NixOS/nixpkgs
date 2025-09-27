{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyglm";
  version = "2.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Zuzu-Typ";
    repo = "PyGLM";
    tag = version;
    hash = "sha256-oLPZ6sCIAt12iolcSBNXEjbHGE4ou+dgoFhB400pyRk=";
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

  meta = with lib; {
    homepage = "https://github.com/Zuzu-Typ/PyGLM";
    description = "OpenGL Mathematics (GLM) library for Python written in C++";
    changelog = "https://github.com/Zuzu-Typ/PyGLM/releases/tag/${src.tag}";
    license = licenses.zlib;
    maintainers = with maintainers; [ sund3RRR ];
  };
}
