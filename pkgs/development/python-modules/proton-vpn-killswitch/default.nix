{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  proton-core,
  pytestCheckHook,
  pytest-cov-stub,
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

  build-system = [ setuptools ];

  dependencies = [ proton-core ];

  pythonImportsCheck = [ "proton.vpn.killswitch.interface" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  meta = {
    description = "Defines the ProtonVPN kill switch interface";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-killswitch";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sebtm ];
  };
}
