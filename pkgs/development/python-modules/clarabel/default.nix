{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  libiconv,
  numpy,
  scipy,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "clarabel";
  version = "0.8.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-03GEFzlvzLeedKVeDokdHGArwjunh3Zm8cJQL90mI+o=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-9zBr9SUd8jJDSqRX9Xs0mDV5gck/qfqJ3VfEAOz7EsA=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  propagatedBuildInputs = [
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
