{ lib
, buildPythonPackage
, fetchFromGitHub
, agate
, cffi
, click
, colorama
, dbt-extractor
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
  version = "1.5.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ZgP11fVMtXpzo9QaTkejvKl0LzCAkIyGBMcOquBirxQ=";
  };

  sourceRoot = "source/core";

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "agate"
    "click"
    "mashumaro"
    "networkx"
  ];

  propagatedBuildInputs = [
    agate
    cffi
    click
    colorama
    dbt-extractor
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

  meta = with lib; {
    description = "Enables data analysts and engineers to transform their data using the same practices that software engineers use to build applications";
    homepage = "https://github.com/dbt-labs/dbt-core";
    changelog = "https://github.com/dbt-labs/dbt-core/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ mausch tjni ];
  };
}
