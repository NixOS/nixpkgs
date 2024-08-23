{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gobject-introspection,
  setuptools,
  proton-core,
  proton-vpn-network-manager,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "proton-vpn-network-manager-openvpn";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-network-manager-openvpn";
    rev = "refs/tags/v${version}";
    hash = "sha256-eDBcpuz37crfAFX6oysB4FCkSmVLyfLJ0R2L0cZgjRo=";
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
    proton-vpn-network-manager
  ];

  pythonImportsCheck = [ "proton.vpn.backend.linux.networkmanager.protocol" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  meta = {
    description = "Adds support for the OpenVPN protocol using NetworkManager";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-network-manager-openvpn";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sebtm ];
  };
}
