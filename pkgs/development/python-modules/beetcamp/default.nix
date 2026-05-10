{
  lib,
  beets,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  packaging,
  poetry-core,
  pycountry,
  pytest-cov-stub,
  pytestCheckHook,
  rich-tables,
  filelock,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "beetcamp";
  version = "0.24.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snejus";
    repo = "beetcamp";
    tag = finalAttrs.version;
    hash = "sha256-AMHj7rsPAxUUvVg6vri2NnkO9+5NAVwGrWLvNvOtlLs=";
  };

  patches = [
    ./remove-git-pytest-option.diff
  ];

  build-system = [
    poetry-core
  ];

  dependencies = [
    httpx
    packaging
    pycountry
  ];

  nativeBuildInputs = [
    beets
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    pytestCheckHook
    pytest-cov-stub
    rich-tables
    filelock
  ];

  disabledTests = [
    # AssertionError: assert ''
    "test_get_html"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      beets-with-beetcamp = beets.override {
        pluginOverrides = {
          beetcamp = {
            enable = true;
            propagatedBuildInputs = [ finalAttrs.finalPackage ];
          };
        };
      };
    };
  };

  meta = {
    description = "Bandcamp autotagger source for beets (http://beets.io)";
    homepage = "https://github.com/snejus/beetcamp";
    license = lib.licenses.gpl2Only;
    maintainers = [
      lib.maintainers._9999years
    ];
    mainProgram = "beetcamp";
  };
})
