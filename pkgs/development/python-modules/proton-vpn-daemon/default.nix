{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  bcc,
  coreutils,
  python,
  dbus-fast,
  packaging,
  proton-core,
  proton-vpn-api-core,
  psutil,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
  systemd-python,
  wireguard-tools,
}:

buildPythonPackage rec {
  pname = "proton-vpn-daemon";
  version = "0.13.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "proton-vpn-daemon";
    tag = "v${version}";
    hash = "sha256-0CqMGyaHjMktM3N1MfrELprZQZqJD1w/mFaOJvJApZQ=";
  };

  postPatch = ''
    substituteInPlace proton/vpn/daemon/split_tunneling/apps/socket_monitor.py \
      --replace-fail "/usr/bin/wg" "${lib.getExe wireguard-tools}"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    bcc
    dbus-fast
    packaging
    proton-core
    proton-vpn-api-core
    psutil
    systemd-python
    wireguard-tools
  ];

  # Needed for `pythonImportsCheck`, `postBuild` happens between `pythonImportsCheckPhase` and `pytestCheckPhase`.
  postBuild = ''
    # Needed for Permission denied: '/homeless-shelter'
    export HOME=$(mktemp -d)
    export XDG_RUNTIME_DIR=$(mktemp -d)
  '';

  postInstall = ''
    mkdir -p "$out/lib/systemd/system"
    mkdir -p "$out/share/dbus-1/system-services"
    mkdir -p "$out/share/dbus-1/system.d"

    install -Dm644 rpmbuild/SOURCES/systemd.service "$out/lib/systemd/system/proton.VPN.service"
    install -Dm644 rpmbuild/SOURCES/dbus.service "$out/share/dbus-1/system-services/me.proton.vpn.split_tunneling.service"
    install -Dm644 rpmbuild/SOURCES/dbus.conf "$out/share/dbus-1/system.d/me.proton.vpn.split_tunneling.conf"

    substituteInPlace "$out/lib/systemd/system/proton.VPN.service" \
      --replace-fail "/usr/bin/python3" "${lib.getExe python}"

    substituteInPlace "$out/share/dbus-1/system-services/me.proton.vpn.split_tunneling.service" \
      --replace-fail "/bin/false" "${lib.getExe' coreutils "false"}"
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
  ];

  pythonImportsCheck = [
    "proton.vpn.daemon"
    "proton.vpn.daemon.split_tunneling"
  ];

  meta = {
    description = "Daemons for Proton VPN Linux client";
    homepage = "https://github.com/ProtonVPN/proton-vpn-daemon";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };
}
