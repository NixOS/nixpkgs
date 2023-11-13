{ lib
, buildPythonPackage
, fetchFromGitHub
}:
buildPythonPackage rec {
  pname = "PyGLM";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "Zuzu-Typ";
    repo = "PyGLM";
    rev = "${version}";
    hash = "sha256-+On4gqfB9hxuINQdcGcrZyOsphfylUNq7tB2uvjsCkE=";
    fetchSubmodules = true;
  };

  meta = with lib; {
    homepage = "https://github.com/Zuzu-Typ/PyGLM";
    description = "An OpenGL Mathematics (GLM) library for Python written in C++";
    license = licenses.zlib;
    maintainers = with maintainers; [ sund3RRR ];
  };
}
