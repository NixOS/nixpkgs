{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "impacket";
  version = "0.9.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1sq1698g7wqj731h24f7gr4lc0fz0mxrqv6mm3j4hm2j6h3rrbr6";
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
