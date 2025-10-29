{
  lib,
  arrow,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  pytestCheckHook,
  pythonOlder,
  pytz,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-datemath";
  version = "3.0.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nickmaccarthy";
    repo = "python-datemath";
    tag = "v${version}";
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

  meta = {
    description = "Python module to emulate the date math used in SOLR and Elasticsearch";
    homepage = "https://github.com/nickmaccarthy/python-datemath";
    changelog = "https://github.com/nickmaccarthy/python-datemath/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
