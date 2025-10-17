{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  ordered-set,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mixbox";
  version = "1.0.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "CybOXProject";
    repo = "mixbox";
    tag = "v${version}";
    hash = "sha256-qK3cKOf0s345M1pVFro5NFhDj4lch12UegOY1ZUEOBQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    lxml
    ordered-set
    python-dateutil
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mixbox" ];

  enabledTestPaths = [ "test/*.py" ];

  disabledTests = [
    # Tests are out-dated
    "test_serialize_datetime_as_date"
    "test_preferred_prefixes"
  ];

  meta = {
    description = "Library of common code leveraged by cybox, maec and stix";
    homepage = "https://github.com/CybOXProject/mixbox";
    changelog = "https://github.com/CybOXProject/mixbox/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
