{
  buildRedist,
  cuda_cudart,
  cuda_nvml_dev,
  cuda_profiler_api,
  cudaNamePrefix,
  lib,
  nccl-ep,
  stdenv,
  stdenvNoCC,
}:
let
  # Supply selectors to buildRedist directly: overrideAttrs runs after its
  # defaults and would hide the loss of caller-provided output mappings.
  profiler = buildRedist (finalAttrs: {
    redistName = "cuda";
    pname = "cuda_profiler_api";
    outputs = [
      "out"
      "bin"
    ];
    outputDev = "bin";
    outputInclude = "bin";
    outputLib = "bin";
    outputToPatterns.bin = [ "*" ];
    env.profilerHeader = "${placeholder finalAttrs.outputInclude}/include/cudaProfiler.h";
    setupHook = builtins.toFile "cuda-profiler-output-test.sh" ''
      export CUDA_TEST_PROFILER_HEADER=@profilerHeader@
    '';
    postInstall = ''
      mkdir -p "''${!outputLib}/lib"
      ln -s "''${!outputInclude}/include/cudaProfiler.h" \
        "''${!outputLib}/lib/profiler-header"
    '';
  });
  runtimes = {
    named = cuda_cudart.overrideAttrs {
      outputs = [
        "out"
        "stubs"
      ];
    };
    fallback = cuda_cudart.overrideAttrs {
      outputs = [
        "out"
        "lib"
      ];
    };
    explicit = cuda_cudart.overrideAttrs (old: {
      outputs = [
        "out"
        "dev"
      ];
      outputInclude = "out";
      outputStubs = "dev";
      passthru = old.passthru // {
        outputToPatterns = old.passthru.outputToPatterns // {
          dev = [ "lib/stubs" ];
        };
      };
    });
  };
  profilerOut = cuda_profiler_api.overrideAttrs {
    outputs = [
      "out"
      "dev"
    ];
    outputInclude = "out";
  };
  profilersNoDev = lib.genAttrs [ "include" "out" ] (
    outputInclude:
    cuda_profiler_api.overrideAttrs {
      outputs = [
        "out"
        "include"
      ];
      inherit outputInclude;
      outputDev = "include";
      setupHook = builtins.toFile "cuda-profiler-default-output-hook.sh" ''
        export CUDA_TEST_DEFAULT_OUTPUT_ACTIVATED=1
      '';
    }
  );
  defaultOutputConsumers = lib.mapAttrs (
    name: component:
    stdenv.mkDerivation {
      name = "${cudaNamePrefix}-tests-redist-outputs-default-input-${name}";
      strictDeps = true;
      buildInputs = [ component ];
      buildCommand = ''
        mkdir "$out"
        cat > caller.c <<'C'
        #if !__has_include(<cudaProfiler.h>)
        #error the default input does not reach the declared header output
        #endif
        int main(void) { return 0; }
        C
        "$CC" caller.c -o "$out/caller"
        test "$CUDA_TEST_DEFAULT_OUTPUT_ACTIVATED" = 1
      '';
    }
  ) profilersNoDev;
  nvmlLegacy = cuda_nvml_dev.overrideAttrs { __structuredAttrs = false; };
  legacyConsumer = stdenv.mkDerivation {
    name = "${cudaNamePrefix}-tests-redist-outputs-unstructured";
    strictDeps = true;
    buildInputs = [ nvmlLegacy ];
    buildCommand = ''
      mkdir "$out"
      echo '#include <nvml.h>
      int main(void) { return sizeof(nvmlMemory_t) == 0; }' > caller.c
      "$CC" caller.c -o "$out/caller"
      [[ $NIX_CFLAGS_COMPILE == *'${nvmlLegacy.include}/include'* ]]
    '';
  };
  runtimeSplit = cuda_cudart.overrideAttrs (old: {
    outputs = [
      "out"
      "dev"
      "samples"
    ];
    outputInclude = "dev";
    outputStatic = "samples";
    outputStubs = "samples";
    passthru = old.passthru // {
      outputToPatterns = old.passthru.outputToPatterns // {
        samples = [
          "**/*.a"
          "lib/stubs"
        ];
      };
    };
  });
  nvmlSplit = cuda_nvml_dev.overrideAttrs (old: {
    outputs = [
      "out"
      "dev"
      "samples"
    ];
    outputInclude = "dev";
    outputStubs = "samples";
    passthru = old.passthru // {
      outputToPatterns = old.passthru.outputToPatterns // {
        samples = [ "lib/stubs" ];
      };
    };
  });
in
stdenvNoCC.mkDerivation {
  name = "${cudaNamePrefix}-tests-redist-outputs";
  strictDeps = true;
  buildInputs = [ profiler.bin ];
  buildCommand = ''
    test "$CUDA_TEST_PROFILER_HEADER" = '${profiler.bin}/include/cudaProfiler.h'
    test -f "$CUDA_TEST_PROFILER_HEADER"
    test -f '${profiler.bin}/lib/profiler-header'
    touch "$out"
  '';

  passthru.tests.stubs = stdenv.mkDerivation {
    name = "${cudaNamePrefix}-tests-redist-outputs-stubs";
    strictDeps = true;
    buildCommand = ''
      mkdir "$out"
      echo 'extern int cuInit(unsigned int); int main(void) { return cuInit(0); }' > caller.c
    ''
    + lib.concatMapAttrsStringSep "\n" (
      name: runtime:
      let
        # Exercise a consumer's actual flags, without building NCCL-EP. Merely
        # checking the output attribute would miss a path baked into a consumer.
        consumer = nccl-ep.override { cuda_cudart = runtime; };
        ldflags = lib.removePrefix "LDFLAGS=" (
          lib.findFirst (lib.hasPrefix "LDFLAGS=") (throw "NCCL-EP has no LDFLAGS") consumer.makeFlags
        );
      in
      ''
        test -f '${lib.getOutput runtime.outputStubs runtime}/lib/stubs/libcuda.so'
        "$CC" caller.c ${lib.escapeShellArg ldflags} -lcuda -o "$out/${name}"
        "$READELF" -d "$out/${name}" | grep -F 'Shared library: [libcuda.so.1]'
      ''
    ) runtimes;
  };

  passthru.tests.propagation = stdenv.mkDerivation {
    name = "${cudaNamePrefix}-tests-redist-outputs-propagation";
    strictDeps = true;
    # Let mkDerivation choose each development input. Selecting the payload
    # outputs here would hide a broken propagatedBuildOutputs contract.
    buildInputs = [
      profilerOut
      runtimeSplit
      nvmlSplit
    ];
    buildCommand = ''
      mkdir "$out"
      ln -s '${legacyConsumer}' "$out/unstructured"
      ln -s '${defaultOutputConsumers.include}' "$out/default-input-include"
      ln -s '${defaultOutputConsumers.out}' "$out/default-input-out"
      cat > caller.c <<'C'
      #if !__has_include(<cudaProfiler.h>)
      #error declared profiler headers are not reachable
      #endif
      #include <cuda_runtime_api.h>
      #include <nvml.h>
      int main(void) {
        int version;
        return cudaRuntimeGetVersion(&version);
      }
      C
      "$CC" caller.c -lcudart -o "$out/shared"
      "$CC" caller.c -lcudart_static -ldl -lpthread -lrt -o "$out/static"
      echo 'extern int cuInit(unsigned int); int main(void) { return cuInit(0); }' > driver.c
      "$CC" driver.c -L'${runtimeSplit.samples}/lib/stubs' -lcuda -o "$out/driver"
      echo '#include <nvml.h>
      int main(void) { return nvmlInit_v2(); }' > nvml.c
      "$CC" nvml.c -L'${nvmlSplit.samples}/lib/stubs' -lnvidia-ml -o "$out/nvml"
      test -L '${nvmlSplit.samples}/lib/stubs/libnvidia-ml.so.1'

      # Required archives/stubs use a nonstandard output name. Both caller
      # additions resolving to samples must activate it only once.
      for dependency in '${runtimeSplit.samples}' '${nvmlSplit.samples}'; do
        [[ " ''${pkgsHostTarget[*]} " == *" $dependency "* ]]
      done
      countEdge() {
        local from=$1 to=$2 expected=$3
        local -a inputs=()
        if [[ -f $from/nix-support/propagated-build-inputs ]]; then
          read -r -d "" -a inputs < "$from/nix-support/propagated-build-inputs" || true
        fi
        local input count=0
        for input in "''${inputs[@]}"; do
          [[ $input != "$to" ]] || count=$((count + 1))
        done
        test "$count" = "$expected"
      }
      countEdge '${profilerOut.dev}' '${profilerOut.out}' 1
      countEdge '${profilerOut.out}' '${profilerOut.dev}' 0
      countEdge '${profilersNoDev.include.out}' '${profilersNoDev.include.include}' 1
      countEdge '${profilersNoDev.include.include}' '${profilersNoDev.include.out}' 0
      countEdge '${profilersNoDev.out.out}' '${profilersNoDev.out.include}' 1
      countEdge '${profilersNoDev.out.include}' '${profilersNoDev.out.out}' 0
      countEdge '${nvmlLegacy.dev}' '${nvmlLegacy.out}' 1
      countEdge '${nvmlLegacy.dev}' '${nvmlLegacy.include}' 1
      countEdge '${nvmlLegacy.out}' '${nvmlLegacy.include}' 1
      countEdge '${runtimeSplit.dev}' '${runtimeSplit.out}' 1
      countEdge '${runtimeSplit.dev}' '${runtimeSplit.samples}' 1
      countEdge '${runtimeSplit.out}' '${runtimeSplit.dev}' 0
      countEdge '${runtimeSplit.out}' '${runtimeSplit.samples}' 1
      countEdge '${nvmlSplit.dev}' '${nvmlSplit.samples}' 1
      for output in '${profilerOut.out}' '${profilerOut.dev}' \
          '${runtimeSplit.out}' '${runtimeSplit.dev}' '${runtimeSplit.samples}'; do
        countEdge "$output" "$output" 0
      done
    '';
  };
}
