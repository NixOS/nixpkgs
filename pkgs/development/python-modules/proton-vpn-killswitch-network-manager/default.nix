{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gobject-introspection,
  setuptools,
  networkmanager,
  proton-vpn-api-core,
  proton-vpn-killswitch,
  proton-vpn-logger,
  pycairo,
  pygobject3,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "proton-vpn-killswitch-network-manager";
  version = "0.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-killswitch-network-manager";
    rev = "refs/tags/v${version}";
    hash = "sha256-iUm+hpqgI4jG+1Cd9F6pBjodxHpq9/2ovXRT877biXQ=";
  };

  nativeBuildInputs = [
    # Solves ImportError: cannot import name NM, introspection typelib not found
    gobject-introspection
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    # Needed here for the NM namespace
    networkmanager
    proton-vpn-api-core
    proton-vpn-killswitch
    proton-vpn-logger
    pycairo
    pygobject3
  ];

  pythonImportsCheck = [ "proton.vpn.killswitch.backend.linux.networkmanager" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  meta = {
    description = "Implementation of the proton-vpn-killswitch interface using Network Manager";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-killswitch-network-manager";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sebtm ];
  };
}
