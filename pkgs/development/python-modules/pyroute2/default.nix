{ lib
, buildPythonPackage
, fetchPypi
, importlib-metadata
, mitogen
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyroute2";
  version = "0.7.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hahWY7BIO8c6DmCgG+feZdNikbYWycFCl0E6P1uEQ/M=";
  };

  propagatedBuildInputs = [
    mitogen
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  # Requires root privileges, https://github.com/svinota/pyroute2/issues/778
  doCheck = false;

  pythonImportsCheck = [
    "pyroute2"
    "pr2modules.common"
    "pr2modules.config"
    "pr2modules.ethtool"
    "pr2modules.ipdb"
    "pr2modules.ipset"
    "pr2modules.ndb"
    "pr2modules.nftables"
    "pr2modules.nslink"
    "pr2modules.protocols"
    "pr2modules.proxy"
  ];

  meta = with lib; {
    description = "Python Netlink library";
    homepage = "https://github.com/svinota/pyroute2";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab mic92 ];
    platforms = platforms.unix;
  };
}
