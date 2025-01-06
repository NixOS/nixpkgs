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
  version = "0.22.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-jG1rfamegnX8GXDwqkGFBFzUeycRLDObJvGbxNk6OpM=";
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

  meta = {
    description = "Tool to simplify SVGs";
    mainProgram = "picosvg";
    homepage = "https://github.com/googlefonts/picosvg";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ _999eagle ];
  };
}
