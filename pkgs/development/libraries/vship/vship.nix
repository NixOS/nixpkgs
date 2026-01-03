{
  lib,
  clangStdenv,
  fetchFromGitHub,
  rocmPackages,
  cudaPackages,
  autoAddDriverRunpath,
  pkg-config,
  ffms,
  ffmpeg-headless,
  gpuBackend ? "rocm",
}:
# vship needs a valid GPU backend
assert builtins.elem gpuBackend [
  "cuda"
  "rocm"
];

clangStdenv.mkDerivation (finalAttrs: {
  pname = "vship";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "Line-fr";
    repo = "Vship";
    tag = "v${finalAttrs.version}";
    hash = "sha256-enRdz0oryvERGYKpymKJLmtxThXR0NFkiinvkNAVxi0=";
  };

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optional (gpuBackend == "rocm") rocmPackages.clr
  ++ lib.optionals (gpuBackend == "cuda") [
    cudaPackages.cuda_nvcc
    cudaPackages.cuda_cudart
    autoAddDriverRunpath
  ];

  buildInputs = [
    ffms
    ffmpeg-headless
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  buildFlags =
    lib.optional (gpuBackend == "rocm") "buildall"
    ++ lib.optional (gpuBackend == "cuda") "buildcudaall";

  meta = {
    description = "High-performance Library for GPU-accelerated visual fidelity metrics";
    longDescription = "Easy to use high-performance Library for GPU-accelerated visual fidelity metrics with SSIMULACRA2, Butteraugli & CVVDP";
    homepage = "https://github.com/Line-fr/Vship";
    changelog = "https://github.com/Line-fr/Vship/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      armelclo
    ];
    platforms = lib.platforms.linux;
  };
})
