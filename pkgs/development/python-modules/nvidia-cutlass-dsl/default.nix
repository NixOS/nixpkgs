{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,

  # dependencies
  nvidia-cutlass-dsl-libs-base,
}:

buildPythonPackage (finalAttrs: {
  pname = "nvidia-cutlass-dsl";
  inherit (nvidia-cutlass-dsl-libs-base) version;
  format = "wheel";
  __structuredAttrs = true;

  # Universal metadata-only wheel that just pulls in `nvidia-cutlass-dsl-libs-base`
  # (which actually ships the Python code and the bundled MLIR/CUDA runtime libs).
  src = fetchPypi {
    pname = "nvidia_cutlass_dsl";
    inherit (finalAttrs) version;
    format = "wheel";
    python = "py3";
    dist = "py3";
    hash = "sha256-dlhQx0hooLWgL++/wbOAhCtk5fehyLFlXjIqOxTAFyY=";
  };

  pythonRemoveDeps = [
    # Bundled in nvidia-cutlass-dsl-libs-base
    "nvidia-cutlass-dsl-libs-cu12"
    "nvidia-cutlass-dsl-libs-cu13"
  ];
  dependencies = [
    nvidia-cutlass-dsl-libs-base
  ];

  # Fix `ModuleNotFoundError: No module named 'nvidia_cutlass_dsl'` when
  # importing. It is not needed in Nixpkgs since nvidia-cutlass-dsl-libs-base
  # handles the import and path changes itself.
  postInstall = ''
    rm "$out/${python.sitePackages}/nvidia_cutlass_dsl_packages.pth"
  '';

  pythonImportsCheck = [ "cutlass" ];

  # No tests in the Pypi archive
  doCheck = false;

  meta = {
    description = "NVIDIA CUTLASS Python DSL";
    homepage = "https://github.com/NVIDIA/cutlass";
    changelog = "https://github.com/NVIDIA/cutlass/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.nvidiaCutlassDsl;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.linux;
  };
})
