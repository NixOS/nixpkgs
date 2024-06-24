{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  importlib-metadata,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyroute2";
  version = "0.7.12";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "svinota";
    repo = "pyroute2";
    rev = "refs/tags/${version}";
    hash = "sha256-zB792ZwDWd74YBYvQ5au0t2RWTIAqrWvNtQ/e+ZEk50=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

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
    license = with licenses; [
      asl20 # or
      gpl2Plus
    ];
    maintainers = with maintainers; [
      fab
      mic92
    ];
    platforms = platforms.unix;
  };
}
