{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build
  setuptools,

  # runtime
  looseversion,
  packaging,
  typing-extensions,

  # tests
  pytest-timeout,
  pytest7CheckHook,
}:

buildPythonPackage rec {
  pname = "lightning-utilities";
  version = "0.11.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Lightning-AI";
    repo = "utilities";
    rev = "refs/tags/v${version}";
    hash = "sha256-7fRn7KvB7CEq8keVR8nrf6IY2G8omAQqNX+DPEf+7nc=";
  };

  postPatch = ''
    substituteInPlace src/lightning_utilities/install/requirements.py \
      --replace-fail "from distutils.version import LooseVersion" "from looseversion import LooseVersion"
  '';

  build-system = [ setuptools ];

  dependencies = [
    looseversion
    packaging
    typing-extensions
  ];

  pythonImportsCheck = [ "lightning_utilities" ];

  nativeCheckInputs = [
    pytest-timeout
    pytest7CheckHook
  ];

  disabledTests = [
    "lightning_utilities.core.enums.StrEnum"
    "lightning_utilities.core.imports.RequirementCache"
    "lightning_utilities.core.imports.compare_version"
    "lightning_utilities.core.imports.get_dependency_min_version_spec"
    # weird doctests fail on imports, but providing the dependency
    # fails another test
    "lightning_utilities.core.imports.ModuleAvailableCache"
    "lightning_utilities.core.imports.requires"
    # Failed: DID NOT RAISE <class 'AssertionError'>
    "test_no_warning_call"
  ];

  disabledTestPaths = [
    "docs"
    # doctests that expect docs.txt in the wrong location
    "src/lightning_utilities/install/requirements.py"
  ];

  meta = {
    changelog = "https://github.com/Lightning-AI/utilities/releases/tag/v${version}";
    description = "Common Python utilities and GitHub Actions in Lightning Ecosystem";
    homepage = "https://github.com/Lightning-AI/utilities";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
