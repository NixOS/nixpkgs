{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gobject-introspection,
  setuptools,
  networkmanager,
  proton-core,
  proton-vpn-connection,
  pycairo,
  pygobject3,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "proton-vpn-network-manager";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-network-manager";
    rev = "refs/tags/v${version}";
    hash = "sha256-zw6fzay1zCBIrouDg2EMhaxDLKIYV5TKYK5lQ3v8W6o=";
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
      --replace-fail "--cov=proton/vpn/backend/linux/networkmanager --cov-report html --cov-report term" ""
  '';

  pythonImportsCheck = [ "proton.vpn.backend.linux.networkmanager" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Provides the necessary functionality for other ProtonVPN components to interact with NetworkManager";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-network-manager";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
