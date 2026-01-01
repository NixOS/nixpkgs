{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  libiconv,
<<<<<<< HEAD
  cffi,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  numpy,
  scipy,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "clarabel";
<<<<<<< HEAD
  version = "0.11.1";
=======
  version = "0.10.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-58QcR/Dlmuq5mu//nlivSodT7lJpu+7L1VJvxvQblZg=";
=======
    hash = "sha256-qKIQUFj9fbVHGL5TxIcVpQkQUAsQ/wuPU4BDTmnBChA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
<<<<<<< HEAD
    hash = "sha256-Cmxbz1zPA/J7EeJhGfD4Zt+QvyJK6BOZ+YQAsf8H+is=";
=======
    hash = "sha256-Ohbeavkayl6vMyYX9kVVLRddvVB9gWOxfzdWAOg+gac=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;

<<<<<<< HEAD
  dependencies = [
    cffi
=======
  propagatedBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    numpy
    scipy
  ];

  pythonImportsCheck = [ "clarabel" ];

  # no tests but run the same examples as .github/workflows/pypi.yaml
  checkPhase = ''
    runHook preCheck
    python examples/python/example_sdp.py
    python examples/python/example_qp.py
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/oxfordcontrol/Clarabel.rs/releases/tag/v${version}/CHANGELOG.md";
    description = "Conic Interior Point Solver";
    homepage = "https://github.com/oxfordcontrol/Clarabel.rs";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
