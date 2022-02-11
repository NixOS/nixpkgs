{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "portpicker";
  version = "1.5.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e13b148008adeb2793cf8b55bcd20fdcec4f763f2d3bf3c45f5e5e5d1df7d228";
  };

  meta = {
    description = "A library to choose unique available network ports.";
    homepage = "https://github.com/google/python_portpicker";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ danharaj ];
  };
}
