{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, jinja2
, agate
, click
, colorama
, hologram
, isodate
, Logbook
, mashumaro
, minimal-snowplow-tracker
, networkx
, packaging
, sqlparse
, dbt-extractor
, typing
, werkzeug
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dbt-core";
  version = "0.21.0";

  disabled = pythonOlder "3.7";

  propagatedBuildInputs = [
    jinja2
    agate
    click
    colorama
    hologram
    isodate
    Logbook
    mashumaro
    minimal-snowplow-tracker
    networkx
    packaging
    sqlparse
    dbt-extractor
    typing
    werkzeug
  ];

  checkInputs = [ pytestCheckHook ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dGJsHjKs/D9JESt3Ap2sjdaQLBPb/uGE505ln+KM5Rs=";
  };

  meta = with lib; {
    description = "CLI tool for managing data transformation";
    homepage = "https://getdbt.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ shikanime ];
  };
}
