{ lib
, buildPythonPackage
, fetchFromGitHub
, napalm
, netmiko
, pip
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "napalm-hp-procurve";
  version = "0.7.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "napalm-automation-community";
    repo = pname;
    rev = version;
    hash = "sha256-cO4kxI90krj1knzixRKWxa77OAaxjO8dLTy02VpkV9M=";
  };

  nativeBuildInputs = [
    pip
  ];

  # dependency installation in setup.py doesn't work
  patchPhase = ''
    echo -n > requirements.txt
  '';

  buildInputs = [ napalm ];

  propagatedBuildInputs = [ netmiko ];

  # setup.cfg seems to contain invalid pytest parameters
  preCheck = ''
    rm setup.cfg
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # AssertionError: Some methods vary.
    "test_method_signatures"
    # AttributeError: 'PatchedProcurveDriver' object has no attribute 'platform'
    "test_get_config_filtered"
    # AssertionError
    "test_get_interfaces"
  ];

  meta = with lib; {
    description = "HP ProCurve Driver for NAPALM automation frontend";
    homepage = "https://github.com/napalm-automation-community/napalm-hp-procurve";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
