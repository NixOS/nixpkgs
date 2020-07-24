{ buildPythonPackage
, fetchPypi
, lib
}:

buildPythonPackage rec {
  pname = "javaobj-py3";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "419ff99543469e68149f875abb0db5251cecd350c03d2bfb4c94a5796f1cbc14";
  };

  # Tests assume network connectivity
  doCheck = false;

  meta = {
    description = "Module for serializing and de-serializing Java objects";
    homepage = "https://github.com/tcalmant/python-javaobj";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kamadorueda
    ];
  };
}
