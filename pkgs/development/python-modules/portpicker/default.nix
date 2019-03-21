{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "portpicker";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19c0f950x544ndsdkfhga58x69iiin2vqiz59pqn9mymk2vrlpkg";
  };

  meta = {
    description = "A library to choose unique available network ports.";
    homepage = "https://github.com/google/python_portpicker";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ danharaj ];
  };
}
