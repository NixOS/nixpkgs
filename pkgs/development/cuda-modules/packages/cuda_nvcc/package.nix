{
  backendCC,
  buildRedist,
  cudaAtLeast,
  cudaOlder,
  cccl,
  lib,
  libnvvm,
  libnvptxcompiler,
  cuda_crt,
  cuda_cudart,
  replaceVars,
  runtimeShell,
  stdenv,
}:
let
  cc = backendCC;
  hostCompiler = "${cc}/bin/${cc.targetPrefix}c++";
  ccSuffixSalt = cc.suffixSalt;
  bintoolsSuffixSalt = cc.bintools.suffixSalt or cc.bintools.env.suffixSalt;
  targetCRT = cuda_crt.__spliced.targetTarget or cuda_crt;
  targetCCCL = cccl.__spliced.targetTarget or cccl;
  targetCudart = cuda_cudart.__spliced.targetTarget or cuda_cudart;
  targetPtxCompiler = libnvptxcompiler.__spliced.targetTarget or libnvptxcompiler;

in
buildRedist (finalAttrs: {
  redistName = "cuda";
  pname = "cuda_nvcc";

  # Keep NVCC and NVVM together: consumers expect a single compiler prefix.
  outputs = [
    "out"
  ];
  # Metadata-bearing compiler inputs must retain their setup hook and TARGET
  # dependencies when propagated through a consumer's development output.
  outputDev = finalAttrs.outputBin;

  # The nvcc and cicc binaries contain hard-coded references to /usr
  allowFHSReferences = true;

  # The default runtime describes code emitted by NVCC. Its propagation also
  # supplies CRT and CCCL to consumers, independently of the compiler's HOST.
  depsTargetTargetPropagated = [ targetCudart ];

  # Resolve this output placeholder in NVCC's derivation, not replaceVars'.
  env.nvccPrefix = placeholder finalAttrs.outputBin;
  setupHook = replaceVars ./setup-hook.sh {
    nvccPrefix = null;
    inherit cc hostCompiler;
    bintools = cc.bintools;
  };

  cudaCompilerExecutable = "bin/nvcc";

  brokenAssertions = [
    {
      # This restriction concerns NVCC's selected backend, not the compiler
      # packaging the headers or the project's ordinary C++ compiler.
      # cc-wrapper also uses its libcxx argument for a GNU libstdc++ provider.
      message = "NVCC cannot use libc++ when targeting x86_64-linux";
      assertion = stdenv.targetPlatform.system == "x86_64-linux" -> !(cc.libcxx.isLLVM or false);
    }
    {
      # These CRT headers reference libc++'s removed std::__promote and do not
      # match its device math overloads. Check the selected runtime: choosing an
      # older supported Clang backend deliberately retains that runtime.
      message = "CUDA 12.9/13.3 NVCC math headers are incompatible with libc++ 21 on aarch64-linux";
      assertion =
        !(
          stdenv.targetPlatform.system == "aarch64-linux"
          && (cc.libcxx.isLLVM or false)
          && lib.versions.major cc.libcxx.version == "21"
          && builtins.elem (lib.versions.majorMinor finalAttrs.version) [
            "12.9"
            "13.3"
          ]
        );
    }
  ];

  postInstall =
    let
      oldNvvmDir = lib.concatStringsSep "/" (
        [ "$(TOP)" ]
        ++ lib.optionals (cudaOlder "12.5") [ "$(_NVVM_BRANCH_)" ]
        ++ lib.optionals (cudaAtLeast "12.5") [ "nvvm" ]
      );
      newNvvmDir = "\${!outputBin:?}/nvvm";
    in
    lib.optionalString finalAttrs.finalPackage.meta.available (
      # From CUDA 13.0, NVVM is available as a separate library and not bundled in the NVCC redist.
      lib.optionalString (cudaOlder "13.0") ''
        moveToOutput nvvm "''${!outputBin:?}"
        mv --verbose --no-clobber "${newNvvmDir}/lib64" "${newNvvmDir}/lib"
      ''
      # NVVM is unpacked and made top-level; we cannot make a symlink to it because build systems (like CMake)
      # may take the target and do relative path operations to it.
      + lib.optionalString (cudaAtLeast "13.0") ''
        cp -rv ${libnvvm} "${newNvvmDir}"
        chmod -Rv u+w "${newNvvmDir}"
      ''
      # Retain CUDA 12's bundled PTX compiler API, but use its TARGET library
      # instead of the CPU architecture of the NVCC executable's archive.
      + lib.optionalString (cudaOlder "13.0") ''
        ln -sfn ${lib.getOutput targetPtxCompiler.outputInclude targetPtxCompiler}/include/nvPTXCompiler.h "''${!outputInclude:?}/include/nvPTXCompiler.h"
        ln -sfn ${lib.getOutput targetPtxCompiler.outputStatic targetPtxCompiler}/lib/libnvptxcompiler_static.a "''${!outputLib:?}/lib/libnvptxcompiler_static.a"
      ''
      # These defaults belong beside the executable so they also apply to JIT
      # invocations. The single-output prefix contains HOST's tools/NVVM and
      # TARGET's CRT; the remaining TARGET components have direct store paths.
      # NVIDIA's component archives have no selectable targets/ directory.
      + ''
        substituteInPlace "''${!outputBin:?}/bin/nvcc.profile" \
          --replace-fail '$(_TARGET_SIZE_)' "" \
          ${lib.optionalString (cudaAtLeast "13.0") "--replace-fail '$(TOP)/$(_TARGET_DIR_)/include/cccl' '${lib.getOutput targetCCCL.outputInclude targetCCCL}/include' "} \
          --replace-fail '$(TOP)/$(_TARGET_DIR_)/include' "''${!outputInclude:?}/include" \
          ${
            lib.optionalString (targetCudart.outputStubs != targetCudart.outputLib)
              "--replace-fail '$(TOP)/$(_TARGET_DIR_)/lib/stubs' '${lib.getOutput targetCudart.outputStubs targetCudart}/lib/stubs' "
          }--replace-fail '$(TOP)/$(_TARGET_DIR_)/lib' '${lib.getOutput targetCudart.outputLib targetCudart}/lib' \
          --replace-fail '${oldNvvmDir}/' "${newNvvmDir}/"

        # FindCUDAToolkit reads the first INCLUDES/LIBRARIES assignments in
        # nvcc's verbose output, before any CUDA language has been enabled.
        # Publish complete defaults in those assignments rather than tracing
        # an empty reset followed by progressively accumulated paths. Keep
        # NVIDIA's SYSTEM_INCLUDES as well: CCCL remains a system include for
        # compilers, while CMake can discover it through INCLUDES.
        local nvccIncludes='"-I${lib.getOutput targetCudart.outputInclude targetCudart}/include" '"\"-I''${!outputInclude:?}/include\""
        local ccclIncludes='"-I${lib.getOutput targetCCCL.outputInclude targetCCCL}/include"'
        # CUDA 12 previously prepended CCCL; CUDA 13 also marks it as system.
        nvccIncludes="${
          if cudaOlder "13.0" then "$ccclIncludes $nvccIncludes" else "$nvccIncludes $ccclIncludes"
        }"
        substituteInPlace "''${!outputBin:?}/bin/nvcc.profile" \
          --replace-fail "\"-I''${!outputInclude:?}/include\"" "$nvccIncludes"
        sed -i \
          -e 's/^INCLUDES[[:space:]]*+=/INCLUDES =/' \
          -e 's/^LIBRARIES[[:space:]]*=+/LIBRARIES = $(NIX_NVCC_LIBRARIES)/' \
          "''${!outputBin:?}/bin/nvcc.profile"
      ''
      # Keep nvcc.profile beside the real executable; CMake also relies on
      # finding nvvm relative to the public compiler prefix.
      + ''
        rm -rf "''${!outputInclude:?}/include/crt"
        ln -s ${lib.getOutput targetCRT.outputInclude targetCRT}/include/crt "''${!outputInclude:?}/include/crt"
        mv "''${!outputBin:?}/bin/nvcc" "''${!outputBin:?}/bin/.nvcc-unwrapped"
        # Use the compiler output's identity, including all overrides, for
        # role markers. Hashes also count as Nix store references, so using
        # another output's hash here could introduce an output cycle.
        local suffixSalt="''${nvccPrefix##*/}"
        suffixSalt="''${suffixSalt%%-*}"
        mkdir -p "''${!outputBin:?}/nix-support/bin"
        # NVCC's --lib phase invokes unprefixed ar by default. Cross bintools
        # expose a prefixed name; keep its alias private to NVCC's PATH.
        ln -s ${cc.bintools}/bin/${cc.targetPrefix}ar "''${!outputBin:?}/nix-support/bin/ar"
        substitute ${../../../../build-support/setup-hooks/role.bash} "''${!outputBin:?}/nix-support/role.bash" \
          --subst-var-by name nvcc-wrapper \
          --subst-var-by wrapperName NVCC \
          --subst-var-by suffixSalt "$suffixSalt"
        substitute ${./nvcc-wrapper.sh} "''${!outputBin:?}/bin/nvcc" \
          --subst-var nvccPrefix \
          --subst-var-by shell ${runtimeShell} \
          --subst-var-by suffixSalt "$suffixSalt" \
          --subst-var-by cc ${cc} \
          --subst-var-by bintools ${cc.bintools} \
          --subst-var-by hostCompiler ${hostCompiler} \
          --subst-var-by ccSuffixSalt ${ccSuffixSalt} \
          --subst-var-by bintoolsSuffixSalt ${bintoolsSuffixSalt} \
          --subst-var-by nvcc "''${!outputBin:?}/bin/.nvcc-unwrapped"
        chmod +x "''${!outputBin:?}/bin/nvcc"
      ''

    );

  meta = {
    description = "CUDA compiler driver";
    homepage = "https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc";
    mainProgram = "nvcc";
  };
})
