{ lib
, buildPythonPackage
, fetchFromGitHub
, gobject-introspection
, setuptools
, proton-core
, proton-vpn-network-manager
, pytestCheckHook
}:

buildPythonPackage {
  pname = "proton-vpn-network-manager-openvpn";
  version = "0.0.4-unstable-2023-07-05";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-network-manager-openvpn";
    rev = "b79f6732646378ef1b92696de3665ff9560286d3";
    hash = "sha256-Z5X8RRu+1KaZ0pnH7tzGhfeST2W8bxMZnuryLhFjG/g=";
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

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Adds support for the OpenVPN protocol using NetworkManager";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-network-manager-openvpn";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
