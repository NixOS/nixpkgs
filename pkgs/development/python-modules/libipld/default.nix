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
<<<<<<< HEAD
  version = "3.3.2";
=======
  version = "3.2.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "pyproject";
  disabled = pythonOlder "3.8";

  # use pypi, GitHub does not include Cargo.lock
  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-foXM2RNhEOY5Q9lSMrGTyJPjacQGJz0jUWDlzEs5yc4=";
=======
    hash = "sha256-ZUIw/9k4Kl7sKKrU4Nzdk/Ed2H2mVpOdvxODB/KGcSA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
<<<<<<< HEAD
    hash = "sha256-BtFIX6xCJWBkIOzYEr8XohA1jsXC9rhiaMd87pe101w=";
=======
    hash = "sha256-jVZ3Oml/W6Kb9hYEXazF3/ogFHtl43d1YLd8vZFJDa8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    changelog = "https://github.com/MarshalX/python-libipld/releases/tag/v${version}";
=======
    changelog = "https://github.com/MarshalX/python-libipld/blob/v${version}/CHANGES.md";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vji ];
  };
}
