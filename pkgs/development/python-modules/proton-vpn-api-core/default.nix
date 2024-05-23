{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  proton-core,
  proton-vpn-connection,
  proton-vpn-logger,
  proton-vpn-killswitch,
  proton-vpn-session,
  sentry-sdk,
  distro,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "proton-vpn-api-core";
  version = "0.22.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-api-core";
    rev = "refs/tags/v${version}";
    hash = "sha256-BGei6tw6VTKkHmaIWa2VJfKOL5cRUbauOQ7zp1RY9Bo=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    distro
    proton-core
    proton-vpn-connection
    proton-vpn-logger
    proton-vpn-killswitch
    proton-vpn-session
    sentry-sdk
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "--cov=proton/vpn/core/ --cov-report html --cov-report term" ""
  '';

  pythonImportsCheck = [ "proton.vpn.core" ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    # Needed for Permission denied: '/homeless-shelter'
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Acts as a facade to the other Proton VPN components, exposing a uniform API to the available Proton VPN services";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-api-core";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
