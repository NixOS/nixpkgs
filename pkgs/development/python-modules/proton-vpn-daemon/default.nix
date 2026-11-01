{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  coreutils,
  bcc,
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
}:

buildPythonPackage rec {
  pname = "proton-vpn-daemon";
  version = "0.13.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "proton-vpn-daemon";
    tag = "v${version}";
    hash = "sha256-0aHY0aYgEf2OWGcH8ugJSH7viJ9zdf/wTgeb5nkxj6g=";
  };

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
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'entry_points={' 'entry_points={"console_scripts": ["proton-vpn-daemon = proton.vpn.daemon.__main__:run_forever"],'
  '';

  postInstall = ''
    install -Dm644 rpmbuild/SOURCES/dbus.conf \
      $out/share/dbus-1/system.d/me.proton.vpn.split_tunneling.conf
    mkdir -p $out/share/dbus-1/system-services $out/lib/systemd/system
    substitute rpmbuild/SOURCES/dbus.service \
      $out/share/dbus-1/system-services/me.proton.vpn.split_tunneling.service \
      --replace-fail /bin/false ${coreutils}/bin/false \
      --replace-fail SystemdService=proton.VPN.service SystemdService=me.proton.vpn.split_tunneling.service
    substitute rpmbuild/SOURCES/systemd.service \
      $out/lib/systemd/system/me.proton.vpn.split_tunneling.service \
      --replace-fail '/usr/bin/python3 -m proton.vpn.daemon' "$out/bin/proton-vpn-daemon"
  '';

  # Needed for `pythonImportsCheck`, `postBuild` happens between `pythonImportsCheckPhase` and `pytestCheckPhase`.
  postBuild = ''
    # Needed for Permission denied: '/homeless-shelter'
    export HOME=$(mktemp -d)
    export XDG_RUNTIME_DIR=$(mktemp -d)
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
