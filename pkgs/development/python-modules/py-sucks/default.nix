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
  version = "0.9.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mib1185";
    repo = "py-sucks";
    tag = "v${version}";
    hash = "sha256-srj/3x04R9KgbdC6IgbQdgUz+srAx0OttB6Ndb2+Nh4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pycryptodome
    requests
    sleekxmppfs
  ];

  optional-dependencies = {
    cli = [
      click
      pycountry-convert
    ];
  };

  pythonImportsCheck = [ "sucks" ];

  nativeCheckInputs = [
    requests-mock
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTests = [
    # assumes $HOME is at a specific place
    "test_config_file_name"
  ];

  meta = {
    changelog = "https://github.com/mib1185/py-sucks/releases/tag/${src.tag}";
    description = "Library for controlling certain robot vacuums";
    homepage = "https://github.com/mib1185/py-sucks";
    license = lib.licenses.gpl3Only;
    mainProgram = "sucks";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
