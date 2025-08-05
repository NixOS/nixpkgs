{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  gitMinimal,
  hatchling,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "hatch-vcs";
  version = "0.5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "hatch_vcs";
    inherit version;
    hash = "sha256-A5X6EmlANAIVCQw0Siv04qd7y+faqxb0Gze5jJWAn/k=";
  };

  build-system = [ hatchling ];

  dependencies = [
    hatchling
    setuptools-scm
  ];

  nativeCheckInputs = [
    gitMinimal
    pytestCheckHook
  ];

  disabledTests = [
    # incompatible with setuptools-scm>=7
    # https://github.com/ofek/hatch-vcs/issues/8
    "test_write"
  ]
  ++ lib.optionals (pythonOlder "3.11") [
    # https://github.com/pypa/setuptools_scm/issues/1038, fixed in setuptools_scm@8.1.0
    "test_basic"
    "test_root"
    "test_metadata"
  ];

  pythonImportsCheck = [ "hatch_vcs" ];

  meta = with lib; {
    changelog = "https://github.com/ofek/hatch-vcs/releases/tag/v${version}";
    description = "Plugin for Hatch that uses your preferred version control system (like Git) to determine project versions";
    homepage = "https://github.com/ofek/hatch-vcs";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
