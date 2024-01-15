{ lib
, python3
, buildPythonPackage
, fetchFromGitHub
, agate
, cffi
, click
, colorama
, dbt-extractor
, dbt-semantic-interfaces
, hologram
, idna
, isodate
, jinja2
, logbook
, mashumaro
, minimal-snowplow-tracker
, networkx
, packaging
, pathspec
, protobuf
, pythonRelaxDepsHook
, pytz
, pyyaml
, requests
, sqlparse
, typing-extensions
, urllib3
, werkzeug
}:

buildPythonPackage rec {
  pname = "dbt-core";
  version = "1.7.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+2tmLclBZrY9SDCKvQ4QNbI4665BtsrEI1sBSY3GVGM=";
  };

  sourceRoot = "${src.name}/core";

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "agate"
    "click"
    "mashumaro"
    "networkx"
    "logbook"
  ];

  propagatedBuildInputs = [
    agate
    cffi
    click
    colorama
    dbt-extractor
    dbt-semantic-interfaces
    hologram
    idna
    isodate
    jinja2
    logbook
    mashumaro
    minimal-snowplow-tracker
    networkx
    packaging
    pathspec
    protobuf
    pytz
    pyyaml
    requests
    sqlparse
    typing-extensions
    urllib3
    werkzeug
  ] ++ mashumaro.optional-dependencies.msgpack;

  # tests exist for the dbt tool but not for this package specifically
  doCheck = false;

  passthru = {
    withAdapters = python3.pkgs.callPackage ./with-adapters.nix { };
  };

  meta = with lib; {
    description = "Enables data analysts and engineers to transform their data using the same practices that software engineers use to build applications";
    longDescription = ''
      The dbt tool needs adapters to data sources in order to work. The available
      adapters are:

        dbt-bigquery
        dbt-postgres
        dbt-redshift
        dbt-snowflake

      An example of building this package with a few adapters:

        dbt.withAdapters (adapters: [
          adapters.dbt-bigquery
          adapters.dbt-postgres
        ])
    '';
    homepage = "https://github.com/dbt-labs/dbt-core";
    changelog = "https://github.com/dbt-labs/dbt-core/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ mausch tjni ];
    mainProgram = "dbt";
  };
}
