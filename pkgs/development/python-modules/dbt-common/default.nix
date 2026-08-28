{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  writeScript,

  # build-system
  hatchling,

  # dependencies
  dbt-protos,
  agate,
  colorama,
  deepdiff,
  isodate,
  jinja2,
  jsonschema,
  mashumaro,
  opentelemetry-api,
  pathspec,
  protobuf,
  python-dateutil,
  requests,
  typing-extensions,

  # tests
  opentelemetry-sdk,
  pytestCheckHook,
  pytest-mock,
  pytest-xdist,
}:

buildPythonPackage rec {
  pname = "dbt-common";
  version = "1.39.0-unstable-2026-08-11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-common";
    rev = "8d30480347d1539d207c54cfe2413e8ef8884d9c"; # They don't tag releases
    hash = "sha256-avlng40osJQM5CH5Wp2x8gw0nj2Oab1VucD8ve7Mx+U=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "agate"
    # 0.6.x -> 0.7.2 doesn't seem too risky at a glance
    # https://pypi.org/project/isodate/0.7.2/
    "isodate"
    "pathspec"
    "protobuf"
  ];

  dependencies = [
    dbt-protos
    agate
    colorama
    deepdiff
    isodate
    jinja2
    jsonschema
    mashumaro
    opentelemetry-api
    pathspec
    protobuf
    python-dateutil
    requests
    typing-extensions
  ]
  ++ mashumaro.optional-dependencies.msgpack;

  nativeCheckInputs = [
    opentelemetry-sdk
    pytestCheckHook
    pytest-xdist
    pytest-mock
  ];

  disabledTests = [
    # flaky test: https://github.com/dbt-labs/dbt-common/issues/280
    "TestFindMatching"
    # KeyError
    "test_recorded_function_with_override_and_additional_fields"
    "test_recorded_function_with_override_and_additional_optional_fields"
  ];

  pythonImportsCheck = [ "dbt_common" ];

  passthru.updateScript = writeScript "update-dbt-common" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p git common-updater-scripts perl

    tmpdir="$(mktemp -d)"
    git clone --depth=1 "${src.gitRepoUrl}" "$tmpdir"

    pushd "$tmpdir"

    newVersionNumber=$(perl -pe 's/version = "([\d.]+)"/$1/' dbt_common/__about__.py | tr -d '\n')
    newRevision=$(git show -s --pretty='format:%H')
    newDate=$(git show -s --pretty='format:%cs')
    newVersion="$newVersionNumber-unstable-$newDate"
    popd

    rm -rf "$tmpdir"
    update-source-version --rev="$newRevision" "python3Packages.dbt-common" "$newVersion"
    perl -pe 's/^(.*version = ")([\d\.]+)(.*)$/''${1}'"''${newVersion}"'";/' \
      -i 'pkgs/development/python-modules/dbt-common/default.nix'
  '';

  meta = {
    description = "Shared common utilities for dbt-core and adapter implementations use";
    homepage = "https://github.com/dbt-labs/dbt-common";
    changelog = "https://github.com/dbt-labs/dbt-common/blob/main/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
