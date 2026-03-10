{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  uv-build,

  # nativeBuildInputs
  beets-minimal,

  # dependencies
  mediafile,

  # tests
  pytestCheckHook,
  beets-audible,
  pytest-xdist,
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

  postPatch = ''
    # nixpkgs ships uv-build 0.10.0; relax the upstream build backend bound.
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.11.21,<0.12" "uv_build"
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
    pytest-xdist
    reflink
    toml
    typeguard
    writableTmpDirAsHomeHook
  ];

  pytestFlags = [
    "-rfEs"
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
