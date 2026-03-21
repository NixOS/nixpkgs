{
  lib,
  config,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  ispc,
  ninja,
  pkg-config,
  cudaPackages,

  # buildInputs
  boost,
  fmt,
  hyperscan,
  onetbb,
  opencv,

  # tests
  versionCheckHook,

  # passthru
  nix-update-script,

  cudaSupport ? config.cudaSupport,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "todds";
  version = "0.4.1";

  patches = [ ./TBB-version.patch ];

  src = fetchFromGitHub {
    owner = "todds-encoder";
    repo = "todds";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-nyYFYym9ZZskkaTPV30+QavdqpvVopnIXXZC6zkeu7c=";
  };

  nativeBuildInputs = [
    cmake
    ispc
    ninja
    pkg-config
  ]
  ++ lib.optionals cudaSupport [
    (lib.getBin cudaPackages.cuda_nvcc)
  ];

  buildInputs = [
    boost
    fmt
    hyperscan
    onetbb
    opencv
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cudart
  ];

  strictDeps = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CPU-based DDS encoder optimized for fast batch conversions with high encoding quality";
    homepage = "https://github.com/todds-encoder/todds";
    changelog = "https://github.com/todds-encoder/todds/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ weirdrock ];
    mainProgram = "todds";
    platforms = lib.platforms.linux;
  };
})
