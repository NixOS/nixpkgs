{ lib, buildPythonPackage, fetchFromGitHub, glfw3 }:

buildPythonPackage rec {
  pname = "glfw";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "FlorianRhiem";
    repo = "pyGLFW";
    rev = "v${version}";
    sha256 = "15kk0zhhja0yqah09wzpg6912zd5bjmk84ab1n5nwryicpg44hqk";
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
