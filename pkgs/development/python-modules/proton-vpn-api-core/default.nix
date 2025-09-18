{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cryptography,
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
}:

buildPythonPackage rec {
  pname = "proton-vpn-api-core";
  version = "0.42.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-api-core";
    rev = "v${version}";
    hash = "sha256-sSLBo2nTn7rvtSZqCWZLwca5DRIgqSkImRM6U6/xJ70=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    cryptography
    distro
    jinja2
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
  ];

  nativeCheckInputs = [
    aiohttp
    pyopenssl
    pytest-asyncio
    requests
    pytestCheckHook
    pytest-cov-stub
  ];

  # Needed for `pythonImportsCheck`, `preCheck` happens between `pythonImportsCheckPhase` and `pytestCheckPhase`.
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
      sebtm
      rapiteanu
    ];
  };
}
