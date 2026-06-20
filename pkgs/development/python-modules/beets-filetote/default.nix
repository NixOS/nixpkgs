{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  buildPythonPackage,

  # build-system
  poetry-core,

  # nativeBuildInputs
  beets-minimal,

  # tests
  pytestCheckHook,
  beets-audible,
  mediafile,
  pytest,
  reflink,
  toml,
  typeguard,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "beets-filetote";
  version = "1.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gtronset";
    repo = "beets-filetote";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qMHjcBrXkVG7U5a1E0yRwNgmg7XinRnK3gnV7jAZLTk=";
  };
  # needed to keep beetsplug a namespace package, othwise other plugins will not be found
  # can be removed with next version
  patches = [
    (fetchpatch2 {
      url = "https://github.com/gtronset/beets-filetote/commit/762cf0c4b60b8f6b38cf39b027de4241f12cef37.patch?full_index=1";
      hash = "sha256-c7qIECcqwoV4ZOaA/8JYsM6Aym34peWPh7ZLWUxIYSI=";
      excludes = [ "CHANGELOG.md" ];
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail "poetry-core<2.0.0" "poetry-core"
  '';

  build-system = [
    poetry-core
  ];

  nativeBuildInputs = [
    beets-minimal
  ];

  dependencies = [
    mediafile
    reflink
    toml
    typeguard
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

  pytestFlags = [
    # This is the same as:
    #   -r fEs
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
