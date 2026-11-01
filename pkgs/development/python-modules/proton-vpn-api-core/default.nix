{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  cargo,
  cryptography,
  dbus-fast,
  distro,
  fido2,
  gobject-introspection,
  jinja2,
  libmnl,
  libnftnl,
  networkmanager,
  packaging,
  pkg-config,
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
  python,
  requests,
  rustc,
  rustPlatform,
  sentry-sdk,
  setuptools,
}:

buildPythonPackage rec {
  pname = "proton-vpn-api-core";
  version = "5.8.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-api-core";
    rev = "v${version}";
    hash = "sha256-I5yT3PF22vE2rqBsWCH4TLmADjs6n51gN/wqwQUK3cU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-R13FBi9l2OtOW/2V3S5sSB94YHXzbWlIxZPUz76/lv0=";
  };

  # The submodule revision is not available in the public mirror; use the
  # public release matching the version recorded in Cargo.lock.
  postUnpack =
    let
      protunSrc = fetchFromGitHub {
        owner = "ProtonVPN";
        repo = "protun";
        tag = "v2.2.1";
        hash = "sha256-y7FHI72aA8gpe8VLrTgwAMI5pmIIdYcOMyqGzqQr36U=";
      };
    in
    ''
      cp -r ${protunSrc}/. "$sourceRoot/dependencies/protun/"
      chmod -R u+w "$sourceRoot/dependencies/protun"
    '';

  nativeBuildInputs = [
    # Needed to recognize the NM namespace
    gobject-introspection
    cargo
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    libmnl
    libnftnl
  ];

  env.PYO3_PYTHON = "${python.interpreter}";

  preBuild = ''
    cargo build --release --offline --locked -j "$NIX_BUILD_CORES"
    cp target/release/libproton_vpn_platform.so proton/vpn/platform.abi3.so
  '';

  propagatedBuildInputs = [
    # Needed here for the NM namespace
    networkmanager
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    cryptography
    dbus-fast
    distro
    fido2
    jinja2
    packaging
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
    "proton.vpn.platform"
    "proton.vpn.backend.firewall_kill_switch"
    "proton.vpn.core"
    "proton.vpn.killswitch.interface"
    "proton.vpn.logging"
    "proton.vpn.session"
    "proton.vpn.split_tunneling"
  ];

  nativeCheckInputs = [
    aiohttp
    pyopenssl
    pytest-asyncio
    requests
    pytestCheckHook
    pytest-cov-stub
  ];

  postInstall = ''
    mkdir -p $out/lib/NetworkManager/VPN $out/share/dbus-1/system-services $out/lib/systemd/system
    install -Dm755 target/release/nm-protun-service -t $out/libexec
    install -Dm755 target/release/proton-vpn-kill-switch-service -t $out/libexec
    install -Dm644 resources/nm-protun-service.conf \
      $out/share/dbus-1/system.d/nm-protun-service.conf
    install -Dm644 resources/proton-vpn-kill-switch.conf \
      $out/share/dbus-1/system.d/me.proton.vpn.kill_switch.conf
    substitute resources/nm-protun.name $out/lib/NetworkManager/VPN/nm-protun.name \
      --replace-fail 'program=$PWD/target/debug/nm-protun-service' "program=$out/libexec/nm-protun-service"
    substitute resources/proton-vpn-kill-switch.dbus-service \
      $out/share/dbus-1/system-services/me.proton.vpn.kill_switch.service \
      --replace-fail /usr/libexec/proton-vpn-kill-switch-service "$out/libexec/proton-vpn-kill-switch-service"
    substitute resources/proton-vpn-kill-switch-boot.service \
      $out/lib/systemd/system/proton-vpn-kill-switch-boot.service \
      --replace-fail /usr/libexec/proton-vpn-kill-switch-service "$out/libexec/proton-vpn-kill-switch-service"

    # Needed for Permission denied: '/homeless-shelter'
    export HOME=$(mktemp -d)
    export XDG_RUNTIME_DIR=$(mktemp -d)
  '';

  preCheck = ''
    # The timezone path tests use the conventional system zoneinfo directory.
    export PYTHONTZPATH=/usr/share/zoneinfo
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

  # Register through networking.networkmanager.plugins so both NetworkManager
  # and libnm can discover Protun, and its D-Bus policies are installed.
  passthru.networkManagerPlugin = "VPN/nm-protun.name";

  meta = {
    description = "Acts as a facade to the other Proton VPN components, exposing a uniform API to the available Proton VPN services";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-api-core";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      anthonyroussel
      rapiteanu
    ];
  };
}
