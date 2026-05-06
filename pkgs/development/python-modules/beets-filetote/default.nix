{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  poetry-core,

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
  version = "1.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gtronset";
    repo = "beets-filetote";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6pMKhsnUG25jbTKWbGiA0tp5QKAHwxPE3/4iVJz3SYk=";
  };

  patches = [
    # Fix test imports: add the source tree's beetsplug/ to beetsplug.__path__
    # so relative imports resolve when loading filetote via importlib.
    ./fix-test-imports.patch
  ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail "poetry-core<2.0.0" "poetry-core"

    # Replace beetsplug/__init__.py with a namespace package extend_path.
    # The upstream __init__.py turns beetsplug into a regular package, which
    # shadows the beets namespace package and breaks all other beets plugins.
    echo 'from pkgutil import extend_path; __path__ = extend_path(__path__, __name__)' \
      > beetsplug/__init__.py
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

  pytestFlagsArray = [
    "-rfEs"
  ];

  meta = {
    description = "Beets plugin to move non-music files during the import process";
    homepage = "https://github.com/gtronset/beets-filetote";
    changelog = "https://github.com/gtronset/beets-filetote/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ dansbandit ];
    license = lib.licenses.mit;
    inherit (beets-minimal.meta) platforms;
  };
})
