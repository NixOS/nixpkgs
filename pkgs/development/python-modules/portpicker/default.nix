{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "portpicker";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rwn5ca7ns3yh6bp785zdd2l4018ccpd5i0m2d1fsd9nhxvcgkfj";
  };

  meta = {
    description = "A library to choose unique available network ports.";
    homepage = "https://github.com/google/python_portpicker";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ danharaj ];
  };
}
