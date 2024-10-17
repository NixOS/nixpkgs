{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gobject-introspection,
  setuptools,
  networkmanager,
  proton-core,
  proton-vpn-api-core,
  proton-vpn-connection,
  pycairo,
  pygobject3,
  pytest-asyncio,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "proton-vpn-network-manager";
  version = "0.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-network-manager";
    rev = "refs/tags/v${version}";
    hash = "sha256-hTJE9sUjPMsE9d0fIA/OhoasumtfsWuFwn0aTm10PN4=";
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
    proton-vpn-connection
    pycairo
    pygobject3
  ];

  pythonImportsCheck = [ "proton.vpn.backend.linux.networkmanager" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-asyncio
  ];

  meta = {
    description = "Provides the necessary functionality for other ProtonVPN components to interact with NetworkManager";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-network-manager";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sebtm ];
  };
}
