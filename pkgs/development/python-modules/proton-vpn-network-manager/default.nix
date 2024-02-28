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
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "proton-vpn-network-manager";
  version = "0.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-network-manager";
    rev = "refs/tags/v${version}";
    hash = "sha256-UEXoIFLB3/q3G3ASrgsXxF21iT5rCWm4knGezcmxmnk=";
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
