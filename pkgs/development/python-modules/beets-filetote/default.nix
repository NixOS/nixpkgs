{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  uv-build,

  # nativeBuildInputs
  beets-minimal,

  # tests
  pytestCheckHook,
  mediafile,
  typeguard,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "beets-filetote";
  version = "1.3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gtronset";
    repo = "beets-filetote";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W5ZZ30LzZLXSMxBBIEQB03Fh04ovETfacZE5gA4oqVM=";
  };

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
