{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  click,
  pycountry-convert,
  pycryptodome,
  requests,
  sleekxmppfs,
  requests-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "py-sucks";
  version = "0.9.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mib1185";
    repo = "py-sucks";
    rev = "refs/tags/v${version}";
    hash = "sha256-MjlE5HdxChAgV/O7cD3foqkmKie7FgRRxvOcW+NAtfA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    pycountry-convert
    pycryptodome
    requests
    sleekxmppfs
  ];

  pythonImportsCheck = [ "sucks" ];

  nativeCheckInputs = [
    requests-mock
    pytestCheckHook
  ];

  disabledTests = [
    # assumes $HOME is at a specific place
    "test_config_file_name"
  ];

  meta = {
    changelog = "https://github.com/mib1185/py-sucks/releases/tag/v${version}";
    description = "Library for controlling certain robot vacuums";
    homepage = "https://github.com/mib1185/py-sucks";
    license = lib.licenses.gpl3Only;
    mainProgram = "sucks";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
