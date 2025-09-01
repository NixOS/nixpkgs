{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyroute2";
  version = "0.9.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "svinota";
    repo = "pyroute2";
    tag = version;
    hash = "sha256-D603ZrLbc/6REx6X0bMvZzeyo0fgTsFL7J+iRTiQLgQ=";
  };

  build-system = [ setuptools ];

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

  postPatch = ''
    patchShebangs util
    make VERSION
  '';

  meta = with lib; {
    description = "Python Netlink library";
    homepage = "https://github.com/svinota/pyroute2";
    changelog = "https://github.com/svinota/pyroute2/blob/${src.tag}/CHANGELOG.rst";
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
