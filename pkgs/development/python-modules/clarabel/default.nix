{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, rustPlatform
, libiconv
, numpy
, scipy
}:

buildPythonPackage rec {
  pname = "clarabel";
  version = "0.6.0.post1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oxfordcontrol";
    repo  = "Clarabel.rs";
    rev = "refs/tags/v${version}";
    hash = "sha256-5Mw+3WRMuz3BxLWRdsnXHjetsNrM3EZRZld8lVTNKgo=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} ./Cargo.lock
  '';

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  pythonImportsCheck = [
    "clarabel"
  ];

  # no tests but run the same examples as .github/workflows/pypi.yaml
  checkPhase = ''
    runHook preCheck
    python examples/python/example_sdp.py
    python examples/python/example_qp.py
    runHook postCheck
  '';

  meta = {
    changelog = "https://github.com/oxfordcontrol/Clarabel.rs/releases/tag/v${version}/CHANGELOG.md";
    description = "Conic Interior Point Solver";
    homepage = "https://github.com/oxfordcontrol/Clarabel.rs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ a-n-n-a-l-e-e ];
  };
}
