{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, proton-core
, pytestCheckHook
}:

buildPythonPackage {
  pname = "proton-vpn-killswitch";
  version = "0.2.0-unstable-2023-09-05";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-killswitch";
    rev = "6e84588ea6ae0946141d4b44b2cf5df8465d5eba";
    hash = "sha256-eFwWN8E+nIDpbut8tkWqXucLhzm7HaLAMBIbAq/X2eo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    proton-core
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=proton --cov-report=html --cov-report=term" ""
  '';

  pythonImportsCheck = [ "proton.vpn.killswitch.interface" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Defines the ProtonVPN kill switch interface";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-killswitch";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
