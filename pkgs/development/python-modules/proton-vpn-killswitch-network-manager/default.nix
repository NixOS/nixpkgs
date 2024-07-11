{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gobject-introspection,
  setuptools,
  networkmanager,
  proton-vpn-killswitch,
  proton-vpn-logger,
  pycairo,
  pygobject3,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "proton-vpn-killswitch-network-manager";
  version = "0.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-killswitch-network-manager";
    rev = "refs/tags/v${version}";
    hash = "sha256-kN41b6OZ2YXoBsmNZD3NrX4uJChSmm6DVP+5LYwiZMw=";
  };

  nativeBuildInputs = [
    # Solves ImportError: cannot import name NM, introspection typelib not found
    gobject-introspection
    setuptools
  ];

  propagatedBuildInputs = [
    # Needed here for the NM namespace
    networkmanager
    proton-vpn-killswitch
    proton-vpn-logger
    pycairo
    pygobject3
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=proton.vpn.killswitch.backend.linux.networkmanager --cov-report=html --cov-report=term" ""
  '';

  pythonImportsCheck = [ "proton.vpn.killswitch.backend.linux.networkmanager" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Implementation of the proton-vpn-killswitch interface using Network Manager";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-killswitch-network-manager";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
