{
  lib,
  fetchFromGitHub,
  fetchpatch,
  buildPythonPackage,

  # build-system
  hatchling,

  # nativeBuildInputs
  beets-minimal,

  # tests
  pytestCheckHook,
  pytest-cov-stub,
  mock,
  pillow,
  tomli,
  typeguard,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "beets-alternatives";
  version = "0.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "beets-alternatives";
    owner = "geigerzaehler";
    tag = "v${version}";
    hash = "sha256-C4EVJwzLhwQJz/iUKrIKUjhYHIpPrETqyQi0DByZM3Y=";
  };

  patches = [
    # Fixes failing tests; see https://github.com/geigerzaehler/beets-alternatives/pull/221
    (fetchpatch {
      url = "https://github.com/geigerzaehler/beets-alternatives/commit/84fdb0fa15225cce1e881b07bddcb52715677915.patch";
      hash = "sha256-rURvP7aNJ+I9bPjk43t8rYujOK1iUS1J4RFMAHfa5AU=";
    })
  ];

  build-system = [
    hatchling
  ];

  nativeBuildInputs = [
    beets-minimal
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    mock
    pillow
    tomli
    typeguard
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Beets plugin to manage external files";
    homepage = "https://github.com/geigerzaehler/beets-alternatives";
    changelog = "https://github.com/geigerzaehler/beets-alternatives/blob/v${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      aszlig
      lovesegfault
    ];
    license = lib.licenses.mit;
  };
}
