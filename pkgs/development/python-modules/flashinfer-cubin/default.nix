{
  lib,
  config,
  buildPythonPackage,
  flashinfer-python,
  fetchurl,
}:
buildPythonPackage (finalAttrs: {
  pname = "flashinfer-cubin";
  # FlashInfer ignores a mismatched one. Bumping flashinfer-python changes the URL: update the hash.
  inherit (flashinfer-python) version;
  format = "wheel";

  # Not on PyPI. Listed on https://flashinfer.ai/whl/flashinfer-cubin/ (1.5 GiB, every architecture)
  src = fetchurl {
    url = "https://github.com/flashinfer-ai/flashinfer/releases/download/v${finalAttrs.version}/flashinfer_cubin-${finalAttrs.version}-py3-none-any.whl";
    hash = "sha256-EVuWBl+i3MFnTHT8sFROwokKb6SoUZsiUdH2qz14AJM=";
  };

  pythonImportsCheck = [ "flashinfer_cubin" ];

  # No tests
  doCheck = false;

  meta = {
    description = "Precompiled cubins for FlashInfer";
    homepage = "https://github.com/flashinfer-ai/flashinfer";
    inherit (flashinfer-python.meta) changelog;
    broken = !config.cudaSupport;
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    teams = [ lib.teams.cuda ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
