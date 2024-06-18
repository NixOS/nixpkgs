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

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    cryptography
    distro
    proton-core
    proton-vpn-logger
    pynacl
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "--cov=proton.vpn.session --cov-report term" ""
  '';

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
  ];

  meta = {
    description = "Provides utility classes to manage VPN sessions";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-session";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ wolfangaukang ];
  };
}
