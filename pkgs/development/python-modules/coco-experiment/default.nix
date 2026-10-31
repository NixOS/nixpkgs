{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,

  # build-system
  cython,
  meson-python,
  numpy,

  # nativeBuildInputs
  colorama,

  # tests
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "coco-experiment";
  version = "2.8.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "numbbo";
    repo = "coco-experiment";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QnoGWvWPVuZvxbCer0LNd8XPJ672flhp3DjxwSTyjPw=";
  };

  postPatch =
    # The version is normally obtained from `git describe`
    ''
      substituteInPlace scripts/fabricate \
        --replace-fail 'COCO_VERSION = git_version()' 'COCO_VERSION = "${finalAttrs.version}"' \
        --replace-fail 'COCO_RUST_VERSION = git_version(format="rust")' 'COCO_RUST_VERSION = "${finalAttrs.version}"'
    ''
    # Relax over-tight build-system pins
    + ''
      substituteInPlace build/python/pyproject.toml \
        --replace-fail '"meson-python >= 0.22"' '"meson-python"' \
        --replace-fail '"wheel", ' ""
    '';

  # Amalgamate the C sources and generate _version.py into build/python
  preBuild = ''
    python scripts/fabricate \
      --skip-c \
      --skip-java \
      --skip-matlab \
      --skip-octave \
      --skip-rust \
      --skip-unit-tests \
      --skip-integration-tests
    cd build/python
  '';

  build-system = [
    cython
    meson-python
    numpy
  ];

  nativeBuildInputs = [
    # meson runs `python src/cocoex/_version.py` to get the version
    python
    colorama
  ];

  dependencies = [
    numpy
  ];

  pythonImportsCheck = [ "cocoex" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # `example/` requires cocopp, scipy and runs full benchmark experiments
  enabledTestPaths = [ "tests" ];

  meta = {
    description = "Benchmarking framework for all types of black-box optimization algorithms";
    homepage = "https://github.com/numbbo/coco-experiment";
    changelog = "https://github.com/numbbo/coco-experiment/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
