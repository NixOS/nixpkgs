{ lib
, buildPythonPackage
, fetchFromGitHub
, glfw3
, pythonOlder
}:

buildPythonPackage rec {
  pname = "glfw";
  version = "2.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "FlorianRhiem";
    repo = "pyGLFW";
    rev = "refs/tags/v${version}";
    hash = "sha256-3K+mDSz4ifVYkUvhd2XDPbhh6UCY4y54YqNLoAYDsP0=";
  };

  # Patch path to GLFW shared object
  patches = [ ./search-path.patch ];

  postPatch = ''
    substituteInPlace glfw/library.py --replace "@GLFW@" '${glfw3}/lib'
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
