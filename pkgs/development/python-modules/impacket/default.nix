{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "impacket";
  version = "0.9.22";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4bf7e7b595356585599b4b2773b8a463d7b9765c97012dcd5a44eb6d547f6a1d";
  };

  disabled = isPy3k;

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Network protocols Constructors and Dissectors";
    homepage = "https://github.com/CoreSecurity/impacket";
    # Modified Apache Software License, Version 1.1
    license = licenses.free;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
