{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
  writeScript,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
buildPythonPackage rec {
  pname = "dbt-common";
  version = "1.37.2-unstable-2025-12-15";
=======
buildPythonPackage {
  pname = "dbt-common";
  version = "1.28.0-unstable-2025-08-14";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-common";
<<<<<<< HEAD
    rev = "88b14473573d0e4e8c3b02d6ee573d346c84b0db"; # They don't tag releases
    hash = "sha256-NnuYga3pHo0dIg6nr15DQINskF1bkKGfWXcUaEK38Kc=";
=======
    rev = "dd34e0a0565620863ff70c0b02421d84fcee8a02"; # They don't tag releases
    hash = "sha256-hG6S+IIAR3Cu69oFapQUVoCdaiEQYeMQ/ekBuAXxPrI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "agate"
<<<<<<< HEAD
    # 0.6.x -> 0.7.2 doesn't seem too risky at a glance
    # https://pypi.org/project/isodate/0.7.2/
    "isodate"
=======
    "deepdiff"
    # 0.6.x -> 0.7.2 doesn't seem too risky at a glance
    # https://pypi.org/project/isodate/0.7.2/
    "isodate"
    "protobuf"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
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

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = "Shared common utilities for dbt-core and adapter implementations use";
    homepage = "https://github.com/dbt-labs/dbt-common";
    changelog = "https://github.com/dbt-labs/dbt-common/blob/main/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
