{
  lib,
  buildPythonPackage,
  fetchPypi,
  jinja2,
  setuptools,
}:

buildPythonPackage rec {
  pname = "glad2";
  version = "2.0.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uEB5ufpATzcXG5Yb3R2NohNw5sgY3vuEgcWz/j1kNto=";
  };

  build-system = [ setuptools ];

  dependencies = [ jinja2 ];

  # no python tests
  doCheck = false;

  pythonImportsCheck = [ "glad" ];

  meta = with lib; {
    description = "Multi-Language GL/GLES/EGL/GLX/WGL Loader-Generator based on the official specifications";
    mainProgram = "glad";
    homepage = "https://github.com/Dav1dde/glad";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}
