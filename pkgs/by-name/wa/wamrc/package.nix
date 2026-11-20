{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  llvm_20,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wamrc";
  version = "2.4.6";

  src = fetchFromGitHub {
    owner = "wasm-micro-runtime";
    repo = "wasm-micro-runtime";
    tag = "WAMR-${finalAttrs.version}";
    hash = "sha256-Lsa7P8QQVWB08UFIidPIsmaXZOtnDxE3C2MzW73Rwtg=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    llvm_20
  ];

  cmakeFlags =
    lib.optionals stdenv.hostPlatform.isDarwin [
      "-DCMAKE_OSX_DEPLOYMENT_TARGET=${stdenv.hostPlatform.darwinSdkVersion}"
    ]
    ++ [
      "-DWAMR_BUILD_WITH_CUSTOM_LLVM=ON"
      "-DLLVM_DIR=${llvm_20.dev}/lib/cmake/llvm"
    ];

  preConfigure = "cd wamr-compiler";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=WAMR-(.*)" ]; };

  meta = {
    description = "WebAssembly Micro Runtime AOT compiler";
    homepage = "https://github.com/wasm-micro-runtime/wasm-micro-runtime";
    license = lib.licenses.asl20;
    mainProgram = "wamrc";
    maintainers = with lib.maintainers; [ bubblepipe ];
    platforms = lib.platforms.unix;
  };
})
