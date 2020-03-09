{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "impacket";
  version = "0.9.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "43ebdb62e179113a55ccd4297316532582be71857b85d85ba187cd6146757397";
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
