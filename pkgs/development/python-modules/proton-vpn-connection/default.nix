{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  proton-core,
  proton-vpn-killswitch,
  proton-vpn-logger,
  jinja2,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "proton-vpn-connection";
  version = "0.14.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-connection";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ze/te0G0tDzyZPGVVqvuJlZoHWJqJ36LnHO+Cy5nxx8=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    jinja2
    proton-core
    proton-vpn-killswitch
    proton-vpn-logger
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "--cov=proton.vpn.connection --cov-report html --cov-report term" ""
  '';

  pythonImportsCheck = [ "proton.vpn.connection" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Permission denied: '/run'
    "test_ensure_configuration_file_is_deleted"
    "test_ensure_generate_is_returning_expected_content"
    "test_ensure_same_configuration_file_in_case_of_duplicate"
    "test_ensure_configuration_file_is_created"
    "test_wireguard_config_content_generation"
    "test_wireguard_with_malformed_credentials"
    "test_wireguard_with_non_certificate"
    "test_wireguard_without_settings"
    # Neiter udp or tcp are working
    "test_ovpnconfig_with_settings"
    "test_ovpnconfig_with_missing_settings_applies_expected_defaults"
    "test_ovpnconfig_with_malformed_params"
    "test_ovpnconfig_with_certificate_and_malformed_credentials"
    "test_ovpnconfig_with_malformed_server"
    "test_ovpnconfig_with_malformed_server_and_credentials"
  ];

  meta = with lib; {
    description = "Defines the interface that VPN connection backends should implement";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-connection";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
