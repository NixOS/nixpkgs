{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
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

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    absl-py
    lxml
    skia-pathops
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # a few tests are failing on aarch64
  doCheck = !stdenv.hostPlatform.isAarch64;

  meta = with lib; {
    description = "Tool to simplify SVGs";
    mainProgram = "picosvg";
    homepage = "https://github.com/googlefonts/picosvg";
    license = licenses.asl20;
    maintainers = with maintainers; [ _999eagle ];
  };
}
