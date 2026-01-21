{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python-dateutil,
  pkg-config,
  rustPlatform,
  setuptools,
  typing-extensions,
  openssl,
  uv,
}:
let
  version = "0.5.8";
  nominal-streaming-src = fetchFromGitHub {
    owner = "nominal-io";
    repo = "nominal-streaming";
    tag = "v${version}";
    hash = "sha256-Lp4WziVtqYKpew8VhviKbImhMjXAeIZlxj/uEV9wqdE=";
  };
in

# Nominal packages should be updated together
# to ensure compatibility.
# nixpkgs-update: no auto update
buildPythonPackage rec {
  pname = "nominal-streaming";
  version = "0.5.8";
  pyproject = true;

  src = nominal-streaming-src;
  sourceRoot = "source/py-nominal-streaming";

  patchPhase = ''
    runHook prePatch
    cp ${src}/Cargo.lock ./
    runHook postPatch
  '';

  env = {
    CARGO_TARGET_DIR = "target";
    OPENSSL_NO_VENDOR = "1";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    src = nominal-streaming-src;
    patches = [ ];
    hash = "sha256-xjanEdZpX2kWJqi0dYXuvoJem9MBTWoU12uAzajsj84=";
  };
  # cargoDeps = rustPlatform.importCargoLock {
  #   lockFile = "${nominal-streaming-src}/Cargo.lock";
  #   # hash = "sha256-xjanEdZpX2kWJqi0dYXuvoJem9MBTWoU12uAzajsj84=";
  # };

  build-system = [
    setuptools
    uv
  ]
  ++ (with rustPlatform; [
    bindgenHook
    cargoSetupHook
    maturinBuildHook
  ]);

  nativeBuildInputs = [
    pkg-config
  ]
  ++ (with rustPlatform; [
    bindgenHook
    cargoSetupHook
    maturinBuildHook
  ]);

  buildInputs = [ openssl ];

  dependencies = [
    python-dateutil
    typing-extensions
  ];

  # propagatedBuildInputs = [ nominal-streaming ];

  pythonImportsCheck = [ "nominal_streaming" ];

  meta = {
    description = "Generated conjure client for the Nominal API";
    homepage = "https://pypi.org/project/nominal-streaming/";
    maintainers = with lib.maintainers; [ alkasm ];
    license = lib.licenses.unfree;
  };
}
