{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, cryptography
, distro
, proton-core
, proton-vpn-logger
, pynacl
, aiohttp
, pyopenssl
, pytest-asyncio
, requests
, pytestCheckHook
}:

buildPythonPackage {
  pname = "proton-vpn-session";
  version = "0.6.2-unstable-2023-10-24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-session";
    rev = "419b25bd1823f78d1219dc4cc441eeaf37646068";
    hash = "sha256-YPyNxbKxw+670bNQZ7U5nljyUjsNJ+k7eL+HpGiSCLk=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cryptography
    distro
    proton-core
    proton-vpn-logger
    pynacl
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=proton.vpn.session --cov-report term" ""
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
