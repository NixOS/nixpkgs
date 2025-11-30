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

let
  version = "0.22.0";
in
buildPythonPackage {
  pname = "beetcamp";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snejus";
    repo = "beetcamp";
    tag = version;
    hash = "sha256-5tcQtvYmXT213mZnzKz2kwE5K22rro++lRF65PjC5X0=";
  };

  patches = [
    ./remove-git-pytest-option.diff
  ];

  build-system = [
    poetry-core
  ];

  dependencies = [
    beets
    httpx
    packaging
    pycountry
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Bandcamp autotagger source for beets (http://beets.io)";
    homepage = "https://github.com/snejus/beetcamp";
    license = lib.licenses.gpl2Only;
    maintainers = [
      lib.maintainers._9999years
    ];
    mainProgram = "beetcamp";
  };
}
