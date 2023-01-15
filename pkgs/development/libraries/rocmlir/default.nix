{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, ninja
, hip
, rocminfo
, git
, libxml2
, libedit
, zlib
, ncurses
, python3
, buildRockCompiler ? false
}:

# Theoretically, we could have our MLIR have an output
# with the source and built objects so that we can just
# use it as the external LLVM repo for this
let
  llvmNativeTarget =
    if stdenv.isx86_64 then "X86"
    else if stdenv.isAarch64 then "AArch64"
    else throw "Unsupported ROCm LLVM platform";
in stdenv.mkDerivation (finalAttrs: {
  pname = "rocmlir";
  version = "5.4.1";

  outputs = [
    "out"
  ] ++ lib.optionals (!buildRockCompiler) [
    "external"
  ];

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "rocMLIR";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-MokE7Ej8mLHTQeLYvKr7PPlsNG6ul91fqfXDlGu5JpI=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ] ++ lib.optionals (!buildRockCompiler) [
    hip
  ];

  buildInputs = [
    git
    libxml2
    libedit
    python3
  ];

  propagatedBuildInputs = [
    zlib
    ncurses
  ];

  cmakeFlags = [
    "-DLLVM_TARGETS_TO_BUILD=AMDGPU;${llvmNativeTarget}"
    "-DLLVM_ENABLE_ZLIB=ON"
    "-DLLVM_ENABLE_TERMINFO=ON"
  ] ++ lib.optionals buildRockCompiler [
    "-DBUILD_FAT_LIBROCKCOMPILER=ON"
  ] ++ lib.optionals (!buildRockCompiler) [
    "-DROCM_PATH=${rocminfo}"
    "-DROCM_TEST_CHIPSET=gfx000"
  ];

  dontBuild = true;
  doCheck = true;

  # Certain libs aren't being generated, try enabling tests next update
  checkTarget = if buildRockCompiler
                then "librockCompiler"
                else "check-mlir-miopen-build-only";

  postInstall = let
    libPath = lib.makeLibraryPath [ zlib ncurses hip stdenv.cc.cc ];
  in lib.optionals (!buildRockCompiler) ''
    mkdir -p $external/lib
    cp -a external/llvm-project/llvm/lib/{*.a*,*.so*} $external/lib
    patchelf --set-rpath $external/lib:$out/lib:${libPath} $external/lib/*.so*
    patchelf --set-rpath $out/lib:$external/lib:${libPath} $out/{bin/*,lib/*.so*}
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
    page = "tags?per_page=2";
    filter = ".[1].name | split(\"-\") | .[1]";
  };

  meta = with lib; {
    description = "MLIR-based convolution and GEMM kernel generator";
    homepage = "https://github.com/ROCmSoftwarePlatform/rocMLIR";
    license = with licenses; [ asl20 ];
    maintainers = teams.rocm.members;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version;
  };
})
