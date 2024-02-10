{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, proton-core
, pytestCheckHook
}:

buildPythonPackage {
  pname = "proton-vpn-logger";
  version = "0.2.1-unstable-2023-05-10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-logger";
    rev = "0acbc1ab41a65cbc9ceb340e3db011e6f89eb65a";
    hash = "sha256-VIggBKopAAKiNdQ5ypG1qI74E2WMDwDSriSuka/DBKA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    proton-core
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=proton/vpn/logging/ --cov-report html --cov-report term" ""
  '';

  pythonImportsCheck = [ "proton.vpn.logging" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    # Needed for Permission denied: '/homeless-shelter'
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "General purpose logging package for the entire ProtonVPN Linux client";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-logger";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
