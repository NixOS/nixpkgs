{ lib
, buildPythonPackage
, fetchPypi
, importlib-metadata
, mitogen
, pyroute2-core
, pyroute2-ethtool
, pyroute2-ipdb
, pyroute2-ipset
, pyroute2-ndb
, pyroute2-nftables
, pyroute2-nslink
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyroute2";
  version = "0.6.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WhqjvCwKrUUBLKvjpva7pc94UIZvTf7j705Bt2DHyKQ=";
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
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  # Requires root privileges, https://github.com/svinota/pyroute2/issues/778
  doCheck = false;

  pythonImportsCheck = [
    "pyroute2"
  ];

  meta = with lib; {
    description = "Python Netlink library";
    homepage = "https://github.com/svinota/pyroute2";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab mic92 ];
    platforms = platforms.unix;
  };
}
