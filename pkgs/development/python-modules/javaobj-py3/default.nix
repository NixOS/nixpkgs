{ buildPythonPackage
, fetchPypi
, lib
}:

buildPythonPackage rec {
  pname = "javaobj-py3";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0j9532i7bnjd0v4a8c36mjj9rsdnbmckk65dh9sbmvnhy3j6jx55";
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
