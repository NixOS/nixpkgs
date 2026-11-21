{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "pdf-inspector";
  version = "0.2.6";
  pyproject = true;

  src = fetchPypi {
    pname = "pdf_inspector";
    inherit (finalAttrs) version;
    hash = "sha256-W7OH85v3qTsCtJGItnC5eY+MzH5Y9o7uWIOlEqoFzrI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-/PTqpmL2JdnK/Ejo3IAK/DqTSVrA9zTmFnmRPoc4tLc=";
  };

  # Non-wasm builds look up the bundled CMaps at runtime under CARGO_MANIFEST_DIR,
  # which is the throwaway build directory, so point it at the installed copy instead.
  postPatch = ''
    substituteInPlace src/tounicode.rs \
      --replace-fail 'Path::new(env!("CARGO_MANIFEST_DIR"))' 'Path::new("${placeholder "out"}/share/pdf-inspector")'
  '';

  postInstall = ''
    mkdir -p $out/share/pdf-inspector/external
    cp -r external/bcmaps $out/share/pdf-inspector/external/
  '';

  build-system = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  maturinBuildFlags = [
    "--features"
    "python"
  ];

  pythonImportsCheck = [ "pdf_inspector" ];

  meta = {
    description = "Fast PDF inspection, classification, and text extraction";
    homepage = "https://github.com/firecrawl/pdf-inspector";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ t4ccer ];
  };
})
