{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  proton-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "proton-vpn-killswitch";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-killswitch";
    rev = "v${version}";
    hash = "sha256-XZqjAhxgIiATJd3JcW2WWUMC1b6+cfZRhXlIPyMUFH8=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ proton-core ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=proton --cov-report=html --cov-report=term" ""
  '';

  pythonImportsCheck = [ "proton.vpn.killswitch.interface" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Defines the ProtonVPN kill switch interface";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-killswitch";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
