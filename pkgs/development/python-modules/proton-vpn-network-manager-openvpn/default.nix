{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gobject-introspection,
  setuptools,
  proton-core,
  proton-vpn-network-manager,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "proton-vpn-network-manager-openvpn";
  version = "0.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-network-manager-openvpn";
    rev = "refs/tags/v${version}";
    hash = "sha256-AHG4jEEv1ihpboQwz6FmNtlqCE83qyOeGzBDHQcvD6o=";
  };

  nativeBuildInputs = [
    # Solves Namespace NM not available
    gobject-introspection
    setuptools
  ];

  propagatedBuildInputs = [
    proton-core
    proton-vpn-network-manager
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=proton.vpn.backend.linux.networkmanager.protocol.openvpn --cov-report html --cov-report term" ""
  '';

  pythonImportsCheck = [ "proton.vpn.backend.linux.networkmanager.protocol" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Adds support for the OpenVPN protocol using NetworkManager";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-network-manager-openvpn";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
