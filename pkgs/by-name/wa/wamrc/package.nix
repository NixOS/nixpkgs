{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  llvmPackages_20,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wamrc";
  version = "2.4.4";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasm-micro-runtime";
    tag = "WAMR-${finalAttrs.version}";
    hash = "sha256-pNudBKnhdR/Ye0m2tVZB/wSfJZYK8+gdCpCp0rDp0o4=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    llvmPackages_20.llvm
  ];

  cmakeFlags =
    lib.optionals stdenv.hostPlatform.isDarwin [
      "-DCMAKE_OSX_DEPLOYMENT_TARGET=${stdenv.hostPlatform.darwinSdkVersion}"
    ]
    ++ [
      "-DWAMR_BUILD_WITH_CUSTOM_LLVM=ON"
      "-DLLVM_DIR=${llvmPackages_20.llvm.dev}/lib/cmake/llvm"
    ];

  preConfigure = "cd wamr-compiler";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=WAMR-(.*)" ]; };

  meta = {
    description = "WebAssembly Micro Runtime AOT compiler";
    homepage = "https://github.com/bytecodealliance/wasm-micro-runtime";
    license = lib.licenses.asl20;
    mainProgram = "wamrc";
    maintainers = with lib.maintainers; [ bubblepipe ];
    platforms = lib.platforms.unix;
  };
})
