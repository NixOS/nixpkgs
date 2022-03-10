{ lib, buildPythonPackage, fetchFromGitHub, glfw3 }:

buildPythonPackage rec {
  pname = "glfw";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "FlorianRhiem";
    repo = "pyGLFW";
    rev = "v${version}";
    sha256 = "sha256-XR6TqIrbCR93Qe9cRMgJ0aT/6ZZFj+6Mz+9GhiMD8lM=";
  };

  # Patch path to GLFW shared object
  patches = [ ./search-path.patch ];
  postPatch = ''
    substituteInPlace glfw/library.py --replace "@GLFW@" '${glfw3}/lib'
  '';
  propagatedBuildInputs = [ glfw3 ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "glfw" ];

  meta = with lib; {
    description = "Python bindings for GLFW";
    homepage = "https://github.com/FlorianRhiem/pyGLFW";
    license = licenses.mit;
    maintainers = [ maintainers.McSinyx ];
  };
}
