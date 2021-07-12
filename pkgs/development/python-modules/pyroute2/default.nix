{ lib
, buildPythonPackage
, fetchPypi
, mitogen
, pyroute2-core
, pyroute2-ethtool
, pyroute2-ipdb
, pyroute2-ipset
, pyroute2-ndb
, pyroute2-nftables
, pyroute2-nslink
}:

buildPythonPackage rec {
  pname = "pyroute2";
  version = "0.6.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "560b48a751b1150056ba553c89a31d563cc18ae2675b3793666adcaeb4fabfda";
  };

  propagatedBuildInputs = [
    mitogen
    pyroute2-core
    pyroute2-ethtool
    pyroute2-ipdb
    pyroute2-ipset
    pyroute2-ndb
    pyroute2-nftables
    pyroute2-nslink
  ];

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
