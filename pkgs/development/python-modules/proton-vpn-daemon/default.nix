{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
  version = "0.13.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "proton-vpn-daemon";
    tag = "v${version}";
    hash = "sha256-0CqMGyaHjMktM3N1MfrELprZQZqJD1w/mFaOJvJApZQ=";
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
