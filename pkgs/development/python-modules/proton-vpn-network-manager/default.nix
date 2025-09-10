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
  pyxdg,
  pytest-asyncio,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "proton-vpn-network-manager";
  version = "0.12.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-network-manager";
    tag = "v${version}";
    hash = "sha256-flZeEdmGXsSFHtlm6HrBtuwOcYJFjWmkMvGgnHL4cPw=";
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
    pyxdg
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

  # Needed for `pythonImportsCheck`, `preCheck` happens between `pythonImportsCheckPhase` and `pytestCheckPhase`.
  preCheck = ''
    # Needed for Permission denied: '/homeless-shelter'
    export HOME=$(mktemp -d)
    export XDG_RUNTIME_DIR=$(mktemp -d)
  '';

  meta = {
    description = "Provides the necessary functionality for other ProtonVPN components to interact with NetworkManager";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-network-manager";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      sebtm
      rapiteanu
    ];
  };
}
