{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  napalm,
  netmiko,
  pip,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  standard-telnetlib,
}:

buildPythonPackage rec {
  pname = "napalm-hp-procurve";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "napalm-automation-community";
    repo = "napalm-hp-procurve";
    tag = version;
    hash = "sha256-cO4kxI90krj1knzixRKWxa77OAaxjO8dLTy02VpkV9M=";
  };

  patchPhase = ''
    # Dependency installation in setup.py doesn't work
    echo -n > requirements.txt
    substituteInPlace setup.cfg \
      --replace " --pylama" ""
  '';

  build-system = [
    setuptools
    pip
  ];

  buildInputs = [ napalm ];

  dependencies = [
    netmiko
    standard-telnetlib
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError: Some methods vary.
    "test_method_signatures"
    # AttributeError: 'PatchedProcurveDriver' object has no attribute 'platform'
    "test_get_config_filtered"
    # AssertionError
    "test_get_interfaces"
    "test_get_facts"
  ];

  pythonImportsCheck = [ "napalm_procurve" ];

  meta = with lib; {
    description = "HP ProCurve Driver for NAPALM automation frontend";
    homepage = "https://github.com/napalm-automation-community/napalm-hp-procurve";
    changelog = "https://github.com/napalm-automation-community/napalm-hp-procurve/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
