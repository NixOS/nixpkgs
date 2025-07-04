{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  glfw3,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "glfw";
  version = "2.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "FlorianRhiem";
    repo = "pyGLFW";
    tag = "v${version}";
    hash = "sha256-MBITnzVNIl+PJ++RN4Dj6sYB1/bSMNHJTDamiG6pEfA=";
  };

  # Patch path to GLFW shared object
  postPatch = ''
    substituteInPlace glfw/library.py --replace "_get_library_search_paths()," "[ '${glfw3}/lib' ],"
  '';

  propagatedBuildInputs = [ glfw3 ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "glfw" ];

  meta = with lib; {
    description = "Python bindings for GLFW";
    homepage = "https://github.com/FlorianRhiem/pyGLFW";
    changelog = "https://github.com/FlorianRhiem/pyGLFW/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.McSinyx ];
  };
}
