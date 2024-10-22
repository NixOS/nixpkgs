{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gobject-introspection,
  apt,
  iproute2,
  setuptools,
  networkmanager,
  proton-core,
  proton-vpn-api-core,
  proton-vpn-local-agent,
  pycairo,
  pygobject3,
  pytest-asyncio,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "proton-vpn-network-manager";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-network-manager";
    rev = "refs/tags/v${version}";
    hash = "sha256-dwWEcLowNlIoxeVQnEpmI+PK18DQRiW4A4qfWHSqRw8=";
  };

  nativeBuildInputs = [
    # Needed to recognize the NM namespace
    gobject-introspection
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    # Needed here for the NM namespace
    networkmanager
    proton-core
    proton-vpn-api-core
    proton-vpn-local-agent
    pycairo
    pygobject3
  ];

  postPatch = ''
    substituteInPlace proton/vpn/backend/linux/networkmanager/killswitch/wireguard/killswitch_connection_handler.py \
      --replace '/usr/sbin/ip' '${iproute2}/bin/ip'
    substituteInPlace proton/vpn/backend/linux/networkmanager/killswitch/wireguard/wgkillswitch.py \
      --replace '/usr/bin/apt' '${apt}/bin/apt'
  '';

  pythonImportsCheck = [
    "proton.vpn.backend.linux.networkmanager"
    "proton.vpn.backend.linux.networkmanager.killswitch.default"
    "proton.vpn.backend.linux.networkmanager.killswitch.wireguard"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-asyncio
  ];

  preCheck = ''
    # Needed for Permission denied: '/homeless-shelter'
    export HOME=$(mktemp -d)
  '';

  meta = {
    description = "Provides the necessary functionality for other ProtonVPN components to interact with NetworkManager";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-network-manager";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sebtm ];
  };
}
