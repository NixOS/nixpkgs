{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pexpect,
  pyserial,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pygatt";
  version = "5.0.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "peplin";
    repo = "pygatt";
    tag = "v${version}";
    hash = "sha256-TMIqC+JvNOLU38a9jkacRAbdmAAd4UekFUDRoAWhHFo=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "setup_requires" "test_requires"
  '';

  pythonRemoveDeps = [ "enum-compat" ];

  build-system = [ setuptools ];

  dependencies = [ pyserial ];

  optional-dependencies.GATTTOOL = [ pexpect ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ]
  ++ optional-dependencies.GATTTOOL;

  pythonImportsCheck = [ "pygatt" ];

  meta = with lib; {
    description = "Python wrapper the BGAPI for accessing Bluetooth LE Devices";
    homepage = "https://github.com/peplin/pygatt";
    changelog = "https://github.com/peplin/pygatt/blob/v${version}/CHANGELOG.rst";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ fab ];
  };
}
