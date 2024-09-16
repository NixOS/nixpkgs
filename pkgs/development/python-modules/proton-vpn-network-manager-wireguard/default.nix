{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gobject-introspection,
  setuptools,
  proton-core,
  proton-vpn-killswitch-network-manager-wireguard,
  proton-vpn-network-manager,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "proton-vpn-network-manager-wireguard";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-network-manager-wireguard";
    rev = "v${version}";
    hash = "sha256-DZXixcm2VwXhbN4buABlkybDgXIg/mbeUVHOpdoj0Kw=";
  };

  nativeBuildInputs = [
    # Solves Namespace NM not available
    gobject-introspection
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    proton-core
    proton-vpn-killswitch-network-manager-wireguard
    proton-vpn-network-manager
  ];

  preCheck = ''
    # Needed for Permission denied: '/homeless-shelter'
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  meta = {
    description = "Adds support for the Wireguard protocol using NetworkManager";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-network-manager-wireguard";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sebtm ];
  };
}
