{
  lib,
  fetchPypi,
  buildPythonPackage,
  rustPlatform,
  nix-update-script,

  # build-system
  maturin,

  # nativeCheckInputs
  pytestCheckHook,
  pytest-benchmark,
  pytest-codspeed,
  pytest-xdist,
}:

buildPythonPackage rec {
  pname = "libipld";
  version = "4.0.0";
  pyproject = true;

  # use pypi, GitHub does not include Cargo.lock
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1CCVEHSDp8Aw8JObk0QgARvKzS5c0ARLIJ/ftkyCCo0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-X4IcMv/oi7UzH9Q//Rm0jOKWPJDs5Ve2ViE/aa6dU+g=";
  };

  build-system = [
    maturin
  ];

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-benchmark
    pytest-codspeed
    pytest-xdist
  ];

  pytestFlags = [ "--benchmark-disable" ];

  disabledTests = [
    # touches network
    "test_decode_car"
  ];

  pythonImportsCheck = [ "libipld" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast Python library to work with IPLD: DAG-CBOR, CID, CAR, multibase";
    homepage = "https://github.com/MarshalX/python-libipld";
    changelog = "https://github.com/MarshalX/python-libipld/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vji ];
  };
}
