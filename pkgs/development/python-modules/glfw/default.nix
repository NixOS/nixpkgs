{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  glfw3,
}:

buildPythonPackage rec {
  pname = "glfw";
  version = "2.11.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "FlorianRhiem";
    repo = "pyGLFW";
    tag = "v${version}";
    hash = "sha256-y936iHh/9Yg08kSF/m40OvXE0YRpRmHTJ0vPZIpmDsA=";
  };

  # Patch path to GLFW shared object
  postPatch = ''
    substituteInPlace glfw/library.py --replace "_get_library_search_paths()," "[ '${glfw3}/lib' ],"
  '';

  propagatedBuildInputs = [ glfw3 ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "glfw" ];

  meta = {
    description = "Python bindings for GLFW";
    homepage = "https://github.com/FlorianRhiem/pyGLFW";
    changelog = "https://github.com/FlorianRhiem/pyGLFW/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.McSinyx ];
  };
}
