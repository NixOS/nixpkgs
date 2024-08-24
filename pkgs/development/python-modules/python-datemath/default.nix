{
  lib,
  arrow,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pythonOlder,
  pytestCheckHook,
  freezegun,
  pytz,
}:

buildPythonPackage rec {
  pname = "python-datemath";
  version = "3.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nickmaccarthy";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-BL+F2oHM49QiwV1/rjXz3wLp+EaTfmc5tAdlsGKq8ag=";
  };

  dependencies = [ arrow ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [
    freezegun
    pytz
  ];

  pytestFlagsArray = [ "tests.py" ];

  pythonImportsCheck = [ "datemath" ];

  meta = {
    description = "Python module to emulate the date math used in SOLR and Elasticsearch";
    homepage = "https://github.com/nickmaccarthy/python-datemath";
     changelog = "https://github.com/nickmaccarthy/python-datemath/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
