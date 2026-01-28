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
  pathspec,
  protobuf,
  python-dateutil,
  requests,
  typing-extensions,

  # tests
  pytestCheckHook,
  pytest-mock,
  pytest-xdist,
}:

buildPythonPackage rec {
  pname = "dbt-common";
  version = "1.37.2-unstable-2026-01-22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-common";
    rev = "5b331b9c50ca5fee959a9e4fa9ecca964549930c"; # They don't tag releases
    hash = "sha256-OF4zKmKVHa9SdiQ1WRLvNoqQd3FWCUr5hK9ZYls9EsY=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "agate"
    # 0.6.x -> 0.7.2 doesn't seem too risky at a glance
    # https://pypi.org/project/isodate/0.7.2/
    "isodate"
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
    pathspec
    protobuf
    python-dateutil
    requests
    typing-extensions
  ]
  ++ mashumaro.optional-dependencies.msgpack;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    pytest-mock
  ];

  disabledTests = [
    # flaky test: https://github.com/dbt-labs/dbt-common/issues/280
    "TestFindMatching"
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
