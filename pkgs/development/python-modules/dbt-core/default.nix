{
  lib,
  agate,
  buildPythonPackage,
  click,
  daff,
  dbt-adapters,
  dbt-common,
  dbt-extractor,
  dbt-semantic-interfaces,
  fetchFromGitHub,
  jinja2,
  logbook,
  mashumaro,
  minimal-snowplow-tracker,
  networkx,
  packaging,
  pathspec,
  protobuf,
  callPackage,
  pythonOlder,
  pytz,
  pyyaml,
  requests,
  setuptools,
  sqlparse,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "dbt-core";
  version = "1.9.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-core";
    tag = "v${version}";
    hash = "sha256-2WFCFzAS3HWx/cwYi1D6LZ0APFp83lGjpP1l7Yfcups=";
  };

  sourceRoot = "${src.name}/core";

  pythonRelaxDeps = [
    "protobuf"
    "agate"
    "click"
    "dbt-common"
    "dbt-semantic-interfaces"
    "logbook"
    "mashumaro"
    "networkx"
    "pathspec"
    "protobuf"
    "urllib3"
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    agate
    click
    daff
    dbt-adapters
    dbt-common
    dbt-extractor
    dbt-semantic-interfaces
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
  ] ++ mashumaro.optional-dependencies.msgpack;

  # tests exist for the dbt tool but not for this package specifically
  doCheck = false;

  passthru = {
    withAdapters = callPackage ./with-adapters.nix { };
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
    changelog = "https://github.com/dbt-labs/dbt-core/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      mausch
      tjni
    ];
    mainProgram = "dbt";
  };
}
