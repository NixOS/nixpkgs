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

  patches = [
    # Fixes a failing test, see:
    # https://github.com/geigerzaehler/beets-alternatives/issues/212
    (fetchpatch {
      url = "https://github.com/geigerzaehler/beets-alternatives/commit/8b75974636897aabcf2ca75fb0987f7beb68f50f.patch";
      hash = "sha256-lIJwuf3UklcJM4m7CO2+aNpPekHXuC5rpPVjK+kb+FQ=";
      includes = [
        "test/cli_test.py"
      ];
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
