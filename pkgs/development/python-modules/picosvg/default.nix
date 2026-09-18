{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools-scm,
  absl-py,
  lxml,
  skia-pathops,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "picosvg";
  version = "0.22.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "picosvg";
    tag = "v${version}";
    hash = "sha256-ocdHF0kYnfllpvul32itu1QtlDrqVeq5sT8Ecb5V1yk=";
  };

  patches = [
    # Fix test failures with skia-pathops 0.9.x (m143)
    # https://github.com/googlefonts/picosvg/pull/331
    (fetchpatch {
      url = "https://github.com/googlefonts/picosvg/commit/885ee64b75f526e938eb76e09fab7d93e946a355.patch";
      hash = "sha256-fR3FfnEPHwSO1rMtmQEr1pyvByTx8T53FxSpuAKWIjw=";
    })
  ];

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    absl-py
    lxml
    skia-pathops
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # a few tests are failing on aarch64
  doCheck = !stdenv.hostPlatform.isAarch64;

  meta = {
    description = "Tool to simplify SVGs";
    mainProgram = "picosvg";
    homepage = "https://github.com/googlefonts/picosvg";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ _999eagle ];
  };
}
