{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  libiconv,
  cffi,
  numpy,
  scipy,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "clarabel";
  version = "0.11.1";
  pyproject = true;

  __structuredAttrs = true;

  # upstream does not provide Cargo.lock outside of PyPI
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-58QcR/Dlmuq5mu//nlivSodT7lJpu+7L1VJvxvQblZg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-Cmxbz1zPA/J7EeJhGfD4Zt+QvyJK6BOZ+YQAsf8H+is=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;

  dependencies = [
    cffi
    numpy
    scipy
  ];

  pythonImportsCheck = [ "clarabel" ];

  nativeCheckInputs = [ pytestCheckHook ];

  postCheck = ''
    python examples/python/example_sdp.py
    python examples/python/example_qp.py
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/oxfordcontrol/Clarabel.rs/releases/tag/v${finalAttrs.version}/CHANGELOG.md";
    description = "Conic Interior Point Solver";
    homepage = "https://github.com/oxfordcontrol/Clarabel.rs";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
