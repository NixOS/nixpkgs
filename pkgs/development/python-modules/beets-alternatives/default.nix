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
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "beets-alternatives";
    owner = "geigerzaehler";
    tag = "v${version}";
    hash = "sha256-leZYXf6Oo/jAKbnJbP+rTnuRsh9P1BQXYAbthMNT60A=";
  };

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
