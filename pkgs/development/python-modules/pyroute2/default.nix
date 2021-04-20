{ lib
, buildPythonPackage
, fetchFromPyPI
}:

buildPythonPackage rec {
  pname = "pyroute2";
  version = "0.5.18";

  src = fetchFromPyPI {
    inherit pname version;
    sha256 = "sha256-CKxAytUsC7Lg8gCHUgWZqpH8zgsiHdJukEIzBCiBC8U=";
  };

  # Requires root privileges, https://github.com/svinota/pyroute2/issues/778
  doCheck = false;

  pythonImportsCheck = [ "pyroute2" ];

  meta = with lib; {
    description = "Python Netlink library";
    homepage = "https://github.com/svinota/pyroute2";
    license = licenses.asl20;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.unix;
  };
}
