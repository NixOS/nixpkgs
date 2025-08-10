{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  agate,
  click,
  daff,
  dbt-adapters,
  dbt-common,
  dbt-extractor,
  dbt-semantic-interfaces,
  jinja2,
  logbook,
  mashumaro,
  networkx,
  packaging,
  pathspec,
  protobuf,
  pydantic,
  pydantic-settings,
  pytz,
  pyyaml,
  requests,
  snowplow-tracker,
  sqlparse,
  typing-extensions,

  # passthru
  callPackage,
}:

buildPythonPackage rec {
  pname = "dbt-core";
  version = "1.10.0b2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-core";
    tag = "v${version}";
    hash = "sha256-MTrdpbPqdakFDmLKRFJ23u9hLgGhZ5T+r4om9HPBjkw=";
  };

  postPatch = ''
    substituteInPlace dbt/utils/artifact_upload.py \
      --replace-fail \
        "from pydantic import BaseSettings" \
        "from pydantic_settings import BaseSettings"
  '';

  sourceRoot = "${src.name}/core";

  pythonRelaxDeps = [
    "agate"
    "click"
    "dbt-common"
    "dbt-semantic-interfaces"
    "logbook"
    "mashumaro"
    "networkx"
    "pathspec"
    "protobuf"
    "pydantic"
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
    networkx
    packaging
    pathspec
    protobuf
    pydantic
    pydantic-settings
    pytz
    pyyaml
    requests
    snowplow-tracker
    sqlparse
    typing-extensions
  ]
  ++ mashumaro.optional-dependencies.msgpack;

  # tests exist for the dbt tool but not for this package specifically
  doCheck = false;

  passthru = {
    withAdapters = callPackage ./with-adapters.nix { };
  };

  meta = {
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
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mausch
      tjni
    ];
    mainProgram = "dbt";
  };
}
