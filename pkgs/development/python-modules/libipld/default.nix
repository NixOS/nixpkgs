{
  lib,
  fetchPypi,
  buildPythonPackage,
  pythonOlder,
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
  version = "3.1.1";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  # use pypi, GitHub does not include Cargo.lock
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-S5qdoOpdhI6foSxwACdhmh437MHaOdvRQkwOkGLynkQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-LMd1M2gCK0i3TJPnUIY/2pskt9Rm/yki4uDX5uQGi8Q=";
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
    changelog = "https://github.com/MarshalX/python-libipld/blob/v${version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vji ];
  };
}
