{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "impacket";
  version = "0.9.21";

  src = fetchPypi {
    inherit pname version;
    sha256 = "912f812564e87c31a162cfe0626f3a6cbc5b6864deedbfefc31f6d321859ade3";
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
    broken = !isPy3k;
  };
}
