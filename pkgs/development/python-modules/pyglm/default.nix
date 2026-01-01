{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyglm";
<<<<<<< HEAD
  version = "2.8.3";
=======
  version = "2.8.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Zuzu-Typ";
    repo = "PyGLM";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-7IN/kqFCwAMeVUrBB/CfCm9bSt1dHMbbLtqVInRFCk0=";
=======
    hash = "sha256-oLPZ6sCIAt12iolcSBNXEjbHGE4ou+dgoFhB400pyRk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/Zuzu-Typ/PyGLM";
    description = "OpenGL Mathematics (GLM) library for Python written in C++";
    changelog = "https://github.com/Zuzu-Typ/PyGLM/releases/tag/${src.tag}";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ sund3RRR ];
=======
  meta = with lib; {
    homepage = "https://github.com/Zuzu-Typ/PyGLM";
    description = "OpenGL Mathematics (GLM) library for Python written in C++";
    changelog = "https://github.com/Zuzu-Typ/PyGLM/releases/tag/${src.tag}";
    license = licenses.zlib;
    maintainers = with maintainers; [ sund3RRR ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
