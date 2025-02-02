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
  version = "0.7.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-owqxNfR1xbx4Mp/X31dSkRVeYFW8rwISTrYQuK0XY5Y=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-Tg9K66WIIAZyua8QlKrlUnpRJRmuxe7ihIr2Vqg79NQ=";
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
