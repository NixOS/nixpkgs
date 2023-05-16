<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchFromGitHub
, napalm
, netmiko
, pip
, pytestCheckHook
}:
=======
{ lib, buildPythonPackage, fetchFromGitHub, setuptools, napalm, netmiko
, pytestCheckHook }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildPythonPackage rec {
  pname = "napalm-hp-procurve";
  version = "0.7.0";
<<<<<<< HEAD
  format = "setuptools";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "napalm-automation-community";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-cO4kxI90krj1knzixRKWxa77OAaxjO8dLTy02VpkV9M=";
  };

  nativeBuildInputs = [
    pip
  ];

=======
    sha256 = "1lspciddkd1w5lfyz35i0qwgpbn5jq9cbqkwjbsvi4kliz229vkh";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # dependency installation in setup.py doesn't work
  patchPhase = ''
    echo -n > requirements.txt
  '';

<<<<<<< HEAD
  buildInputs = [ napalm ];

=======
  buildInputs = [ setuptools napalm ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [ netmiko ];

  # setup.cfg seems to contain invalid pytest parameters
  preCheck = ''
    rm setup.cfg
  '';
<<<<<<< HEAD

  nativeCheckInputs = [ pytestCheckHook ];

=======
  nativeCheckInputs = [ pytestCheckHook ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
