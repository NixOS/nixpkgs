{
  lib,
  breezy,
  build,
  buildPythonPackage,
  fetchFromGitHub,
  git,
  pep517,
  pytestCheckHook,
  setuptools,
  tomli,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "check-manifest";
  version = "0.51";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mgedmin";
    repo = "check-manifest";
    tag = version;
    hash = "sha256-tT6xQZwqJIsyrO9BjWweIeNgYaopziewerVBk0mFVYg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    build
    pep517
    setuptools
  ]
  ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  nativeCheckInputs = [
    git
    pytestCheckHook
  ];

  checkInputs = [ breezy ];

  disabledTests = [
    # Test wants to setup a venv
    "test_build_sdist_pep517_isolated"
  ];

  pythonImportsCheck = [ "check_manifest" ];

  meta = with lib; {
    description = "Check MANIFEST.in in a Python source package for completeness";
    homepage = "https://github.com/mgedmin/check-manifest";
    changelog = "https://github.com/mgedmin/check-manifest/blob/${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ lewo ];
    mainProgram = "check-manifest";
  };
}
