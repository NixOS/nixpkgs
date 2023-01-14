{ lib
, buildPythonPackage
, pythonAtLeast
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pyopengl-accelerate";
  version = "3.1.6";
  disabled = pythonAtLeast "3.11"; # fails to compile

  src = fetchPypi {
    pname = "PyOpenGL-accelerate";
    inherit version;
    sha256 = "sha256-rYowAlbsolIoJh3hb3QeUaMPNPHhsc9oNZ9cYtvNzcM=";
  };

  meta = {
    description = "This set of C (Cython) extensions provides acceleration of common operations for slow points in PyOpenGL 3.x";
    homepage = "http://pyopengl.sourceforge.net/";
    maintainers = with lib.maintainers; [ laikq ];
    license = lib.licenses.bsd3;
  };
}
