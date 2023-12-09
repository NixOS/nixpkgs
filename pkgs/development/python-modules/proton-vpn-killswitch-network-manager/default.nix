{ lib
, buildPythonPackage
, fetchFromGitHub
, gobject-introspection
, setuptools
, networkmanager
, proton-vpn-killswitch
, proton-vpn-logger
, pycairo
, pygobject3
, pytestCheckHook
}:

buildPythonPackage {
  pname = "proton-vpn-killswitch-network-manager";
  version = "0.2.0-unstable-2023-09-05";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-killswitch-network-manager";
    rev = "39d4398f169539e335c1f661e0dfc5551df0e6af";
    hash = "sha256-vmTXMIhXZgRvXeUX/XslT+ShqY60w4P7kJBQzWhA66k=";
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

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Implementation of the proton-vpn-killswitch interface using Network Manager";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-killswitch-network-manager";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
