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
  version = "1.0.0";

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

  doCheck = false;

  postPatch = ''
    substituteInPlace setup.py \
      --replace "Jinja2==2.11.3" "Jinja2>=2.11.3"
  '';

  checkPhase = ''
    $out/bin/dbt --help > /dev/null
  '';

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kL3gHQeLHWc9xJC53v/wfn87cCuSDGX+rm+yfgfOc9I=";
  };

  meta = with lib; {
    description = "CLI tool for managing data transformation";
    homepage = "https://getdbt.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ shikanime ];
  };
}
