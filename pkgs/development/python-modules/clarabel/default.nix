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
  version = "0.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DW0/6IAL5bS11AqOFL1JJmez5GzF2+N2d85e0l8HGdQ=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-NNvrDXBodrO3bxr4X1HEn5uHmHDJ1s9C70lPv7OkSCo=";
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
