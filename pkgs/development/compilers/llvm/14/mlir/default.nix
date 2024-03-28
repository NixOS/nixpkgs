{ lib, stdenv, llvm_meta
, monorepoSrc, runCommand
, cmake
, libllvm
, version

# TODO: python bindings
# TODO: ROCm, CUDA ?
# TODO: Tests (unit+lit), not integration
, enableRunners ? stdenv.hostPlatform == stdenv.buildPlatform
, enableVulkan ? enableRunners
, vulkan-headers
, vulkan-loader
}:

let
  # List of runners to build, native-only
  runners = lib.optionals enableRunners ([
    "cpu-runner" "spirv-cpu-runner"
  ] ++ lib.optional enableVulkan "vulkan-runner");
  # List of binaries to build + install
  # LLVM_{BUILD,INSTALL}_UTILS=ON doesn't seem to work
  bins = map (n: "mlir-" + n) (runners ++ [
    "linalg-ods-yaml-gen" "tblgen" # needed for cross
    "lsp-server" "opt" "pdll" "reduce" "translate" # misc utilities
  ]);
in
stdenv.mkDerivation rec {
  pname = "mlir";
  inherit version;

  src = runCommand "${pname}-src-${version}" {} ''
    mkdir -p "$out"
    cp -r ${monorepoSrc}/cmake "$out"
    cp -r ${monorepoSrc}/${pname} "$out"
  '';

  sourceRoot = "${src.name}/${pname}";

  patches = [
    ./gnu-install-dirs.patch
  ];

  outputs = [ "out" "lib" "dev" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libllvm ]
    ++ lib.optionals enableVulkan [ vulkan-headers vulkan-loader ];

  cmakeFlags = [
    # Documentation suggests packagers may wish to disable, do so until needed
    "-DMLIR_INSTALL_AGGREGATE_OBJECTS=OFF"
  ] ++ lib.optionals enableRunners ([
    "-DMLIR_ENABLE_SPIRV_CPU_RUNNER=ON"
  ] ++ lib.optional enableVulkan "-DMLIR_ENABLE_VULKAN_RUNNER=ON");

  # Patch around check for being built native (maybe because not built w/LLVM?)
  postPatch = lib.optionalString enableRunners ''
    for x in **/CMakeLists.txt; do
      substituteInPlace "$x" --replace 'if(TARGET ''${LLVM_NATIVE_ARCH})' 'if (1)'
    done
  '';

  postBuild = ''
    make ${lib.concatStringsSep " " bins} -j$NIX_BUILD_CORES -l$NIX_BUILD_CORES
  '';

  postInstall = ''
    install -Dm755 -t $out/bin ${lib.concatMapStringsSep " " (x: "bin/${x}") bins}

    mkdir -p $out/share/vim-plugins/
    cp -r ../utils/vim $out/share/vim-plugins/mlir
    install -Dt $out/share/emacs/site-lisp ../utils/emacs/mlir-mode.el
  '';

  meta = llvm_meta // {
    homepage = "https://mlir.llvm.org";
    description = "Multi-Level Intermediate Representation";
    longDescription = ''
      The MLIR project is a novel approach to building reusable and extensible
      compiler infrastructure.
      MLIR aims to address software fragmentation, improve compilation for
      heterogeneous hardware, significantly reduce the cost of building domain
      specific compilers, and aid in connecting existing compilers together.
    '';
  };
}

