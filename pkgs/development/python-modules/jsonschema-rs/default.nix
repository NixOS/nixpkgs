{
  buildPythonPackage,
  fetchPypi,
  hypothesis,
  lib,
  nix-update-script,
  pytestCheckHook,
  pythonOlder,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "jsonschema-rs";
<<<<<<< HEAD
  version = "0.37.4";
=======
  version = "0.33.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  pyproject = true;

  disabled = pythonOlder "3.8";

  # Fetching from Pypi, because there is no Cargo.lock in the GitHub repo.
  src = fetchPypi {
    inherit version;
    pname = "jsonschema_rs";
<<<<<<< HEAD
    hash = "sha256-Z/NvHERccPmXXReoTON/eVk/YjTX6ykoMNd0nl+lj/Q=";
=======
    hash = "sha256-PRi2xwfGra6cgSynLldOHp+HKeVPwAFGFYintXfUPc8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
<<<<<<< HEAD
    hash = "sha256-4M20NK2d2NfWr0P1GUSjukOWyDwzvUAexSH+1k7eS1Y=";
=======
    hash = "sha256-P305DiFzU4UfD1PLLU4ayCfLS714VzkWlB3AM4U5ovk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "jsonschema_rs" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "High-performance JSON Schema validator for Python";
    homepage = "https://github.com/Stranger6667/jsonschema/tree/master/crates/jsonschema-py";
    changelog = "https://github.com/Stranger6667/jsonschema/blob/python-v${version}/crates/jsonschema-py/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = [ lib.teams.apm ];
  };
}
