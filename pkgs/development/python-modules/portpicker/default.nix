{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "portpicker";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f5e9ab798d5d764f14de547bc858d3126d351510fbad974b384940e4a7280a5";
  };

  meta = {
    description = "A library to choose unique available network ports.";
    homepage = "https://github.com/google/python_portpicker";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ danharaj ];
  };
}
