{
  lib,
  fetchFromGitHub,
  fetchpatch,
  buildPythonPackage,

  # build-system
  poetry-core,

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
  version = "0.13.4";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "beets-alternatives";
    owner = "geigerzaehler";
    tag = "v${version}";
    hash = "sha256-jGHRoBBXqJq0r/Gbp7gkuaEFPVMGE6cqQRi84AHTXxQ=";
  };

  patches = [
    # Fixes build failure by ignoring DeprecationWarning during tests.
    (fetchpatch {
      url = "https://github.com/geigerzaehler/beets-alternatives/commit/3c15515edfe62d5d6c8f3fb729bf3dcef41c1ffa.patch";
      hash = "sha256-gZXftDI5PXJ0c65Z1HLABJ2SlDnXU78xxIEt7IGp8RQ=";
      excludes = [
        "poetry.lock"
      ];
    })
  ];

  build-system = [
    poetry-core
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
