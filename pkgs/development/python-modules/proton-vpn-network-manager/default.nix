{ lib
, buildPythonPackage
, fetchFromGitHub
, gobject-introspection
, setuptools
, networkmanager
, proton-core
, proton-vpn-connection
, pycairo
, pygobject3
, pytestCheckHook
}:

buildPythonPackage {
  pname = "proton-vpn-network-manager";
  version = "0.3.0-unstable-2023-09-05";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-network-manager";
    rev = "6ffd04fa0ae88a89d2b733443317066ef23b3ccd";
    hash = "sha256-Bqlwo7U/mwodQarl30n3/BNETqit1MVQUJT+mAhC6AI=";
  };

  nativeBuildInputs = [
    # Needed to recognize the NM namespace
    gobject-introspection
    setuptools
  ];

  propagatedBuildInputs = [
    # Needed here for the NM namespace
    networkmanager
    proton-core
    proton-vpn-connection
    pycairo
    pygobject3
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=proton/vpn/backend/linux/networkmanager --cov-report html --cov-report term" ""
  '';

  pythonImportsCheck = [ "proton.vpn.backend.linux.networkmanager" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Provides the necessary functionality for other ProtonVPN components to interact with NetworkManager";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-network-manager";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
