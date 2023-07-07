{ lib, buildPythonPackage, fetchFromGitHub, setuptools, napalm, netmiko
, pytestCheckHook }:

buildPythonPackage rec {
  pname = "napalm-hp-procurve";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "napalm-automation-community";
    repo = pname;
    rev = version;
    sha256 = "1lspciddkd1w5lfyz35i0qwgpbn5jq9cbqkwjbsvi4kliz229vkh";
  };

  # dependency installation in setup.py doesn't work
  patchPhase = ''
    echo -n > requirements.txt
  '';

  buildInputs = [ setuptools napalm ];
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
