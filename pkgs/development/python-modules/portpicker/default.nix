{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "portpicker";
  version = "1.4.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c2831ff4328a21e928ffc9e52124bcafacaf5816d38a1a72dc329680dc1bb7ba";
  };

  meta = {
    description = "A library to choose unique available network ports.";
    homepage = "https://github.com/google/python_portpicker";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ danharaj ];
  };
}
