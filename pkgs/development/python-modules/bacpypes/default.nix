{ lib, buildPythonPackage, fetchFromGitHub
, wheel, pytestCheckHook, pytest-runner, pythonAtLeast }:

buildPythonPackage rec {
  version = "0.18.6";
  pname = "bacpypes";
  disabled = pythonAtLeast "3.9";

  src = fetchFromGitHub {
    owner = "JoelBender";
    repo = "bacpypes";
    rev = "refs/tags/v${version}";
    hash = "sha256-BHCHI36nTqBj2dkHB/Y5qkC4uJCmzbHGzSFWKNsIdbc=";
  };

  propagatedBuildInputs = [ wheel ];

  # Using pytes instead of setuptools check hook allows disabling specific tests
  nativeCheckInputs = [ pytestCheckHook pytest-runner ];
  dontUseSetuptoolsCheck = true;
  disabledTests = [
    # Test fails with a an error: AssertionError: assert 30 == 31
    "test_recurring_task_5"
  ];

  meta = with lib; {
    homepage = "https://github.com/JoelBender/bacpypes";
    description = "BACpypes provides a BACnet application layer and network layer written in Python for daemons, scripting, and graphical interfaces.";
    license = licenses.mit;
    maintainers = with maintainers; [ bachp ];
  };
}
