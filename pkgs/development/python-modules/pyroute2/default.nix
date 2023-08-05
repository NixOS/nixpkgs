{ lib
, buildPythonPackage
, fetchPypi
, importlib-metadata
, mitogen
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pyroute2";
  version = "0.7.9";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tp2C8UCwd0MX17pA9sX6HXVQmLo/PrYZmC0W51DcYxo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    mitogen
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  # Requires root privileges, https://github.com/svinota/pyroute2/issues/778
  doCheck = false;

  pythonImportsCheck = [
    "pyroute2"
    "pyroute2.common"
    "pyroute2.config"
    "pyroute2.ethtool"
    "pyroute2.ipdb"
    "pyroute2.ipset"
    "pyroute2.ndb"
    "pyroute2.nftables"
    "pyroute2.nslink"
    "pyroute2.protocols"
  ];

  meta = with lib; {
    description = "Python Netlink library";
    homepage = "https://github.com/svinota/pyroute2";
    changelog = "https://github.com/svinota/pyroute2/blob/${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab mic92 ];
    platforms = platforms.unix;
  };
}
