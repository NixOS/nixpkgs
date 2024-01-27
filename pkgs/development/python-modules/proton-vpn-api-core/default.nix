{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, proton-core
, proton-vpn-connection
, proton-vpn-logger
, proton-vpn-killswitch
, proton-vpn-session
, distro
, pytestCheckHook
}:

buildPythonPackage {
  pname = "proton-vpn-api-core";
  version = "0.20.1-unstable-2023-10-10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-api-core";
    rev = "9c03fc30d3ff08559cab3644eadde027b029375d";
    hash = "sha256-vnz1+NazQceAs9KA3Jq0tsJditRoG/LoBR+0wuDzzHk=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    distro
    proton-core
    proton-vpn-connection
    proton-vpn-logger
    proton-vpn-killswitch
    proton-vpn-session
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=proton/vpn/core/ --cov-report html --cov-report term" ""
  '';

  pythonImportsCheck = [ "proton.vpn.core" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    # Needed for Permission denied: '/homeless-shelter'
    export HOME=$(mktemp -d)
  '';

  disabledTestPaths = [
    # Has a single test failing with Permission denied: '/run'
    "tests/test_session.py"
  ];

  meta = with lib; {
    description = "Acts as a facade to the other Proton VPN components, exposing a uniform API to the available Proton VPN services";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-api-core";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
