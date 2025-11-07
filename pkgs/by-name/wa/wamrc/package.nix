{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  llvmPackages,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wamrc";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasm-micro-runtime";
    tag = "WAMR-${finalAttrs.version}";
    hash = "sha256-Rhn26TRyjkR30+zyosfooOGjhvG+ztYtJVQlRfzWEFo=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    llvmPackages.llvm
  ];

  cmakeFlags =
    lib.optionals stdenv.hostPlatform.isDarwin [
      "-DCMAKE_OSX_DEPLOYMENT_TARGET=${stdenv.hostPlatform.darwinSdkVersion}"
    ]
    ++ [
      "-DWAMR_BUILD_WITH_CUSTOM_LLVM=ON"
      "-DLLVM_DIR=${llvmPackages.llvm.dev}/lib/cmake/llvm"
    ];

  sourceRoot = "${finalAttrs.src.name}/wamr-compiler";

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
