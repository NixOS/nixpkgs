{
  lib,
  arrow,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  pytestCheckHook,
  pytz,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-datemath";
  version = "3.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nickmaccarthy";
    repo = "python-datemath";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VwdY6Gmbmoy7EKZjUlWj56uSiE0OdegPiQv+rmigkq8=";
  };

  build-system = [ setuptools ];

  dependencies = [ arrow ];

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
    pytz
  ];

  enabledTestPaths = [ "tests.py" ];

  pythonImportsCheck = [ "datemath" ];

  disabledTests = [
    # Test relies on timezone data that may not be present in the test environment
    "testTimezone"
  ];

  meta = {
    description = "Python module to emulate the date math used in SOLR and Elasticsearch";
    homepage = "https://github.com/nickmaccarthy/python-datemath";
    changelog = "https://github.com/nickmaccarthy/python-datemath/blob/v${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
