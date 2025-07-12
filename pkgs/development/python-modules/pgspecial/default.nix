{
  lib,
  buildPythonPackage,
  click,
  configobj,
  fetchPypi,
  psycopg,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  sqlparse,
}:

buildPythonPackage rec {
  pname = "pgspecial";
  version = "2.1.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bU0jFq/31HlU25nUw5HWwLsmVo68udFR9l2reTi2y+I=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    sqlparse
    psycopg
  ];

  nativeCheckInputs = [
    configobj
    pytestCheckHook
  ];

  disabledTests = [
    # Test requires a Postgresql server
    "test_slash_dp_pattern_schema"
  ];

  meta = with lib; {
    description = "Meta-commands handler for Postgres Database";
    homepage = "https://github.com/dbcli/pgspecial";
    changelog = "https://github.com/dbcli/pgspecial/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
