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
<<<<<<< HEAD
  beetcamp ? null, # For `passthru.tests`.
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
=======
    beets
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    httpx
    packaging
    pycountry
  ];

<<<<<<< HEAD
  nativeBuildInputs = [
    beets
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  passthru = {
    updateScript = nix-update-script { };
    tests = {
      beets-with-beetcamp = beets.override {
        pluginOverrides = {
          beetcamp = {
            enable = true;
            propagatedBuildInputs = [ beetcamp ];
          };
        };
      };
    };
  };
=======
  passthru.updateScript = nix-update-script { };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
