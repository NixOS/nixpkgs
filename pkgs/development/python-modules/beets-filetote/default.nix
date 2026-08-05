{
  lib,
  fetchFromGitHub,
  fetchpatch,
  buildPythonPackage,

  # build-system
  uv-build,

  # nativeBuildInputs
  beets-minimal,

  # tests
  pytestCheckHook,
  beets-audible,
  mediafile,
  reflink,
  toml,
  typeguard,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "beets-filetote";
  version = "1.3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gtronset";
    repo = "beets-filetote";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZrF9Z3Eaem8ZzNJgQoW45MvsNOCoLsd7l/yLQ2pldR0=";
  };

  patches = [
    # Fixes a few test failures needed since beets 2.12, see:
    # https://github.com/gtronset/beets-filetote/issues/328
    # https://github.com/gtronset/beets-filetote/pull/336
    (fetchpatch {
      url = "https://github.com/gtronset/beets-filetote/commit/2684482ebe0cd486512b07621e3904de7faf7dc8.patch";
      # Cause merge conflicts
      excludes = [
        # The changes here mainly include ci related changes, and hence can be
        # disabled.
        "pyproject.toml"
        "CHANGELOG.md"
      ];
      hash = "sha256-zVVJY4+f8A+GBxiHZL8OzLWUUmX9uY25tUoLCkzEHh8=";
    })
    # Fixes test errors with beets 2.13. Upstream PR is
    # https://github.com/gtronset/beets-filetote/pull/351 . It is not merged and not even
    # commented by upstream, so we vendor it instead.
    ./beets2.13.patch
  ];

  # https://github.com/gtronset/beets-filetote/issues/328
  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail "uv_build>=0.11.21,<0.12" "uv-build"
  '';

  build-system = [
    uv-build
  ];

  nativeBuildInputs = [
    beets-minimal
  ];

  dependencies = [
    mediafile
  ];

  nativeCheckInputs = [
    pytestCheckHook
    beets-audible
    mediafile
    reflink
    toml
    typeguard
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Beets plugin to move non-music files during the import process";
    homepage = "https://github.com/gtronset/beets-filetote";
    changelog = "https://github.com/gtronset/beets-filetote/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      dansbandit
      returntoreality
    ];
    license = lib.licenses.mit;
    inherit (beets-minimal.meta) platforms;
  };
})
