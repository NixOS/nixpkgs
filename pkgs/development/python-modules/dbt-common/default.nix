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

buildPythonPackage {
  pname = "dbt-common";
  version = "1.31.0-unstable-2025-09-17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-common";
    rev = "d9d63c2a2968259de1999c54943c9d5608d6520d"; # They don't tag releases
    hash = "sha256-AzH1rZFqEH8sovZZfJykvsEmCedEZWigQFHWHl6/PdE=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "agate"
    "deepdiff"
    # 0.6.x -> 0.7.2 doesn't seem too risky at a glance
    # https://pypi.org/project/isodate/0.7.2/
    "isodate"
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

  passthru.updateScript = writeScript "update-${pname}" ''
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
    update-source-version --rev="$newRevision" "python3Packages.${pname}" "$newVersion"
    perl -pe 's/^(.*version = ")([\d\.]+)(.*)$/''${1}'"''${newVersion}"'";/' \
      -i 'pkgs/development/python-modules/${pname}/default.nix'
  '';

  meta = {
    description = "Shared common utilities for dbt-core and adapter implementations use";
    homepage = "https://github.com/dbt-labs/dbt-common";
    changelog = "https://github.com/dbt-labs/dbt-common/blob/main/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
