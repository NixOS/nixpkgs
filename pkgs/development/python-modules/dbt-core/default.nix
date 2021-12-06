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
, requests
, idna
, cffi
, autopep8
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dbt-core";
  version = "0.21.0";

  disabled = pythonOlder "3.7";

  buildInputs = [ autopep8 ];

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
    requests
    idna
    cffi
  ];

  checkInputs = [
    pytestCheckHook
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "276ced7e9e3cb22e5d7c14748384a5cf5d9002257c0ed50c0e075b68011bb6d0";
  };

  meta = with lib; {
    description = "CLI tool for managing data transformation";
    homepage = "https://getdbt.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ shikanime ];
  };
}
