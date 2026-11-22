{
  lib,
  aws-lc,
  buildPythonPackage,
  fetchFromGitHub,
  pkg-config,
  rustPlatform,

  # tests
  pytest-asyncio,
  pytestCheckHook,
  python-dotenv,
}:
buildPythonPackage (finalAttrs: {
  pname = "opendal";
  version = "0.47.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "opendal";
    # Upstream bundles releases in a single OpenDAL monorepo. Bindings get
    # separate version. Details: https://github.com/NixOS/nixpkgs/issues/567427
    tag = "v0.59.5";
    hash = "sha256-8Agx4CbP5IOV+j8J8EgVPOqmyu4WnCahrGlufe231kU=";
  };

  sourceRoot = "${finalAttrs.src.name}/bindings/python";

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  env = {
    PYO3_USE_ABI3_FORWARD_COMPATIBILITY = 1;
  };

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ aws-lc ];

  pythonImportsCheck = [ "opendal" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    python-dotenv
  ];

  meta = {
    description = "native Python binding for Apache OpenDAL";
    homepage = "https://github.com/apache/opendal/blob/main/bindings/python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
