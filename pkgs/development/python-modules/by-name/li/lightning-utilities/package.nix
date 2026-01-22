{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  jsonargparse,
  looseversion,
  packaging,
  tomlkit,
  typing-extensions,

  # tests
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "lightning-utilities";
  version = "0.15.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Lightning-AI";
    repo = "utilities";
    tag = "v${version}";
    hash = "sha256-0unIL5jylunxTJxFTN+Q4aCFtD5zIHRNWEAWSbw+Fsk=";
  };

  postPatch = ''
    substituteInPlace src/lightning_utilities/install/requirements.py \
      --replace-fail "from distutils.version import LooseVersion" "from looseversion import LooseVersion"
  '';

  build-system = [ setuptools ];

  dependencies = [
    jsonargparse
    looseversion
    packaging
    tomlkit
    typing-extensions
  ];

  pythonImportsCheck = [ "lightning_utilities" ];

  nativeCheckInputs = [
    pytest-timeout
    pytestCheckHook
  ];

  disabledTests = [
    # DocTestFailure
    "lightning_utilities.core.imports.RequirementCache"

    # NameError: name 'operator' is not defined. Did you forget to import 'operator'
    "lightning_utilities.core.imports.compare_version"

    # importlib.metadata.PackageNotFoundError: No package metadata was found for pytorch-lightning==1.8.0
    "lightning_utilities.core.imports.get_dependency_min_version_spec"

    # weird doctests fail on imports, but providing the dependency
    # fails another test
    "lightning_utilities.core.imports.ModuleAvailableCache"
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
