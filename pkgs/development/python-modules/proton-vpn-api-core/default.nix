{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
  aiohttp,
  cryptography,
  distro,
  fido2,
  gobject-introspection,
  iproute2,
  jinja2,
  networkmanager,
  proton-core,
  proton-vpn-local-agent,
  pycairo,
  pygobject3,
  pynacl,
  pyopenssl,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pyxdg,
  requests,
  sentry-sdk,
  setuptools,
=======
  cryptography,
  fido2,
  setuptools,
  jinja2,
  proton-core,
  pynacl,
  aiohttp,
  pyopenssl,
  pytest-asyncio,
  requests,
  sentry-sdk,
  pyxdg,
  distro,
  pytestCheckHook,
  pytest-cov-stub,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "proton-vpn-api-core";
<<<<<<< HEAD
  version = "4.14.1";
=======
  version = "4.13.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-api-core";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-xyCjzcSasLGm2DMMViI1wpzcLd0mmaBvIyI1HrtW+Gg=";
  };

  postPatch = ''
    substituteInPlace proton/vpn/backend/networkmanager/killswitch/wireguard/killswitch_connection_handler.py \
      --replace-fail '["/usr/sbin/ip", "route"]' '["${iproute2}/bin/ip", "route"]'
  '';

  nativeBuildInputs = [
    # Needed to recognize the NM namespace
    gobject-introspection
  ];

  propagatedBuildInputs = [
    # Needed here for the NM namespace
    networkmanager
  ];

=======
    hash = "sha256-oFTlN/mi4TACmqbebKirYdqDEYzUejK4SKbKgFWONDo=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  build-system = [
    setuptools
  ];

  dependencies = [
    cryptography
    distro
    fido2
    jinja2
<<<<<<< HEAD
    proton-core
    proton-vpn-local-agent
    pycairo
    pygobject3
    pynacl
    pyxdg
    sentry-sdk
  ];

  pythonImportsCheck = [
    "proton.vpn.backend.networkmanager.core"
    "proton.vpn.backend.networkmanager.killswitch.default"
    "proton.vpn.backend.networkmanager.killswitch.wireguard"
    "proton.vpn.backend.networkmanager.protocol.openvpn"
    "proton.vpn.backend.networkmanager.protocol.wireguard"
    "proton.vpn.connection"
    "proton.vpn.core"
    "proton.vpn.killswitch.interface"
    "proton.vpn.logging"
    "proton.vpn.session"
    "proton.vpn.split_tunneling"
=======
    pynacl
    proton-core
    sentry-sdk
    pyxdg
  ];

  pythonImportsCheck = [
    "proton.vpn.core"
    "proton.vpn.connection"
    "proton.vpn.killswitch.interface"
    "proton.vpn.logging"
    "proton.vpn.session"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  nativeCheckInputs = [
    aiohttp
    pyopenssl
    pytest-asyncio
    requests
    pytestCheckHook
    pytest-cov-stub
  ];

<<<<<<< HEAD
  # Needed for `pythonImportsCheck`, `postInstall` happens between `pythonImportsCheckPhase` and `pytestCheckPhase`.
=======
  # Needed for `pythonImportsCheck`, `preCheck` happens between `pythonImportsCheckPhase` and `pytestCheckPhase`.
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  postInstall = ''
    # Needed for Permission denied: '/homeless-shelter'
    export HOME=$(mktemp -d)
    export XDG_RUNTIME_DIR=$(mktemp -d)
  '';

  disabledTests = [
    # Permission denied: '/run'
    "test_ensure_configuration_file_is_created"
    "test_ovpnconfig_with_certificate"
    "test_ovpnconfig_with_settings"
    "test_wireguard_config_content_generation"
    "test_wireguard_with_non_certificate"
    "test_ensure_generate_is_returning_expected_content"
    "test_ensure_same_configuration_file_in_case_of_duplicate"
    "test_ensure_configuration_file_is_deleted"
  ];

  meta = {
    description = "Acts as a facade to the other Proton VPN components, exposing a uniform API to the available Proton VPN services";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-api-core";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
<<<<<<< HEAD
      anthonyroussel
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      sebtm
      rapiteanu
    ];
  };
}
