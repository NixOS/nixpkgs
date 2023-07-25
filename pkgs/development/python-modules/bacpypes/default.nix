{ lib
, buildPythonPackage
, fetchFromGitHub
, wheel
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bacpypes";
  version = "0.18.6";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "JoelBender";
    repo = "bacpypes";
    rev = "refs/tags/v${version}";
    hash = "sha256-BHCHI36nTqBj2dkHB/Y5qkC4uJCmzbHGzSFWKNsIdbc=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," "" \
      --replace "(3, 8): 'py34'," "(3, 8): 'py34', (3, 9): 'py34', (3, 10): 'py34', (3, 11): 'py34', (3, 12): 'py34',"
  '';

  propagatedBuildInputs = [
    wheel
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Test fails with a an error: AssertionError: assert 30 == 31
    "test_recurring_task_5"
  ];

  pythonImportsCheck = [
    "bacpypes"
  ];

  meta = with lib; {
    description = "Module for the BACnet application layer and network layer";
    homepage = "https://github.com/JoelBender/bacpypes";
    changelog = "https://github.com/JoelBender/bacpypes/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bachp ];
  };
}
