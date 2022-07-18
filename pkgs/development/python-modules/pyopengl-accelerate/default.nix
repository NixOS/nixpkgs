{ lib
, buildPythonPackage
, pythonAtLeast
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pyopengl-accelerate";
  version = "3.1.5";
  disabled = pythonAtLeast "3.10"; # fails to compile

  src = fetchPypi {
    pname = "PyOpenGL-accelerate";
    inherit version;
    sha256 = "01iggy5jwxv7lxnj51zbmlbhag9wcb7dvrbwgi97i90n0a5m3r8j";
  };

  meta = {
    description = "This set of C (Cython) extensions provides acceleration of common operations for slow points in PyOpenGL 3.x";
    homepage = "http://pyopengl.sourceforge.net/";
    maintainers = with lib.maintainers; [ laikq ];
    license = lib.licenses.bsd3;
  };
}
