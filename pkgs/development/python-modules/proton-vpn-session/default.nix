{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cryptography,
  distro,
  proton-core,
  proton-vpn-logger,
  pynacl,
  aiohttp,
  pyopenssl,
  pytest-asyncio,
  requests,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "proton-vpn-session";
  version = "0.6.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-session";
    rev = "refs/tags/v${version}";
    hash = "sha256-/5ju/2bxhqK6JWchkxFe3amBKHtO98GCVQWIrUsn+nQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    cryptography
    distro
    proton-core
    proton-vpn-logger
    pynacl
  ];

  pythonImportsCheck = [ "proton.vpn.session" ];

  postInstall = ''
    # Needed for Permission denied: '/homeless-shelter'
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [
    aiohttp
    pyopenssl
    pytest-asyncio
    requests
    pytestCheckHook
    pytest-cov-stub
  ];

  meta = {
    description = "Provides utility classes to manage VPN sessions";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-session";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sebtm ];
  };
}
