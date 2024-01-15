{ lib
, buildPythonPackage
, fetchFromGitHub
, glfw3
, pythonOlder
}:

buildPythonPackage rec {
  pname = "glfw";
  version = "2.6.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "FlorianRhiem";
    repo = "pyGLFW";
    rev = "refs/tags/v${version}";
    hash = "sha256-ANydW+4uLIJelUdDCHZ6WJgIJHNXzdc9jK/nZbZHi+I=";
  };

  # Patch path to GLFW shared object
  postPatch = ''
    substituteInPlace glfw/library.py --replace "_get_library_search_paths()," "[ '${glfw3}/lib' ],"
  '';

  propagatedBuildInputs = [
    glfw3
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "glfw"
  ];

  meta = with lib; {
    description = "Python bindings for GLFW";
    homepage = "https://github.com/FlorianRhiem/pyGLFW";
    changelog = "https://github.com/FlorianRhiem/pyGLFW/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.McSinyx ];
  };
}
