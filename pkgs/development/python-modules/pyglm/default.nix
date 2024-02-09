{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyglm";
  version = "2.7.1-rev1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Zuzu-Typ";
    repo = "PyGLM";
    rev = "refs/tags/${version}";
    hash = "sha256-MA/NoeKv6yxXL9A36SBqU7GNuPbCKDvxpOkWP8OmED4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "glm"
  ];

  meta = with lib; {
    homepage = "https://github.com/Zuzu-Typ/PyGLM";
    description = "An OpenGL Mathematics (GLM) library for Python written in C++";
    changelog = "https://github.com/Zuzu-Typ/PyGLM/releases/tag/${src.rev}";
    license = licenses.zlib;
    maintainers = with maintainers; [ sund3RRR ];
  };
}
