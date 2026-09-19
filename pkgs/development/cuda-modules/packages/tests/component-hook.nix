{
  backendStdenv,
  cuda_cudart,
  cudaComponentHook,
  cudaMajorMinorVersion,
  cuda_nvcc,
  cuda_profiler_api,
  cudaNamePrefix,
  cudatoolkit,
  lib,
  testers,
  writeShellScriptBin,
}:
let
  inherit (lib) getExe getOutput;
  # Assertions embedded in strings are not spliced by mkDerivation.
  buildNvcc = cuda_nvcc.__spliced.buildHost or cuda_nvcc;
  buildBuildNvcc = cuda_nvcc.__spliced.buildBuild or cuda_nvcc;
  buildTargetNvcc = cuda_nvcc.__spliced.buildTarget or cuda_nvcc;
  buildCudart = cuda_cudart.__spliced.buildBuild or cuda_cudart;
  targetCudart = cuda_cudart.__spliced.targetTarget or cuda_cudart;
  buildComponentHook = cudaComponentHook.__spliced.buildHost or cudaComponentHook;
  dependencyRoles = [
    {
      splice = "buildBuild";
      offsets = "-1:-1";
      compiler = true;
    }
    {
      splice = "buildHost";
      offsets = "-1:0";
      compiler = true;
    }
    {
      splice = "buildTarget";
      offsets = "-1:1";
      compiler = true;
    }
    {
      splice = "hostHost";
      offsets = "0:0";
      compiler = false;
    }
    {
      splice = "hostTarget";
      offsets = "0:1";
      compiler = false;
    }
    {
      splice = "targetTarget";
      offsets = "1:1";
      compiler = false;
    }
  ];
  runCommand =
    name: attrs: buildCommand:
    backendStdenv.mkDerivation (
      attrs
      // {
        inherit buildCommand name;
      }
    );
  mkTestComponent =
    {
      componentName,
      cudaMajorMinorVersion ? null,
      cudaCompilerExecutable ? null,
      install,
    }:
    backendStdenv.mkDerivation (
      {
        pname = componentName;
        version = "1";
        dontUnpack = true;
        strictDeps = true;

        nativeBuildInputs = [ cudaComponentHook ];
        cudaPublishComponent = true;

        installPhase = ''
          runHook preInstall
          ${install}
          runHook postInstall
        '';
      }
      // lib.optionalAttrs (cudaMajorMinorVersion != null) { inherit cudaMajorMinorVersion; }
      // lib.optionalAttrs (cudaCompilerExecutable != null) { inherit cudaCompilerExecutable; }
    );
  expectSetupFailure =
    {
      name,
      buildInputs,
      message,
    }:
    testers.testBuildFailure' {
      drv =
        runCommand "${cudaNamePrefix}-tests-component-hook-${name}"
          {
            __structuredAttrs = true;
            strictDeps = true;
            inherit buildInputs;
          }
          ''
            touch "$out"
          '';
      expectedBuilderLogEntries = [ message ];
    };
  cudartInclude = getOutput cuda_cudart.outputInclude cuda_cudart;
  cudartLib = getOutput "lib" cuda_cudart;
  inactiveCompiler = mkTestComponent {
    componentName = "inactive_nvcc";
    cudaCompilerExecutable = "bin/nvcc";
    install = ''
      mkdir -p "$out/bin"
      touch "$out/bin/nvcc"
      chmod +x "$out/bin/nvcc"
    '';
  };
  plainDependency = runCommand "${cudaNamePrefix}-tests-component-hook-plain-dependency" { } ''
    touch "$out"
  '';
  # stdenv installs setupHook after fixupOutputHooks, and only into dev.
  # Both outputs must publish components; the dev hook must preserve its
  # package-specific behavior even when that hook returns early.
  setupHookComponent =
    (mkTestComponent {
      componentName = "existing_setup_hook";
      inherit cudaMajorMinorVersion;
      install = ''
        mkdir -p "$out" "$dev"
      '';
    }).overrideAttrs
      {
        outputs = [
          "out"
          "dev"
        ];
        setupHook = builtins.toFile "cuda-component-test-setup-hook.sh" ''
          export CUDA_COMPONENT_EXISTING_SETUP_HOOK=preserved
          return 0
        '';
      };
  invalidCompiler = mkTestComponent {
    componentName = "invalid_compiler";
    cudaCompilerExecutable = "bin";
    install = ''
      mkdir -p "$out/bin"
    '';
  };
  invalidCompilerTest = testers.testBuildFailure' {
    drv = invalidCompiler;
    expectedBuilderLogEntries = [ "compiler is not an executable file" ];
  };
  incompatibleVersionComponent = mkTestComponent {
    componentName = "incompatible_version";
    cudaMajorMinorVersion = "0.0";
    install = ''
      mkdir "$out"
    '';
  };
  incompatibleVersions = expectSetupFailure {
    name = "incompatible-versions";
    buildInputs = [
      cuda_cudart
      incompatibleVersionComponent
    ];
    message = "conflicting CUDA major-minor versions";
  };
  duplicateCudart = mkTestComponent {
    componentName = "cuda_cudart";
    inherit cudaMajorMinorVersion;
    install = ''
      mkdir "$out"
    '';
  };
  duplicateComponent = expectSetupFailure {
    name = "duplicate-component";
    buildInputs = [
      cuda_cudart
      duplicateCudart
    ];
    message = "conflicting output cuda_cudart:out";
  };
  assertions = ''

    assertEqual() {
      local variableName="$1"
      local expected="$2"
      local actual="''${!variableName-}"
      if [[ "$actual" != "$expected" ]]; then
        echo "$variableName differs:" >&2
        echo "  expected: $expected" >&2
        echo "  actual:   $actual" >&2
        exit 1
      fi
    }

    assertListContains() {
      local delimiter="$1"
      local variableName="$2"
      local expected="$3"
      local value="''${!variableName-}"
      local entry
      local -a entries=()

      IFS="$delimiter" read -r -a entries <<<"$value"
      for entry in "''${entries[@]}"; do
        [[ "$entry" != "$expected" ]] || return 0
      done

      echo "$variableName does not contain $expected: $value" >&2
      exit 1
    }

    assertListCount() {
      local delimiter="$1"
      local variableName="$2"
      local expected="$3"
      local expectedCount="$4"
      local value="''${!variableName-}"
      local entry count=0
      local -a entries=()

      IFS="$delimiter" read -r -a entries <<<"$value"
      for entry in "''${entries[@]}"; do
        [[ "$entry" != "$expected" ]] || ((count += 1))
      done
      [[ "$count" == "$expectedCount" ]] || {
        echo "$variableName contains $expected $count times, expected $expectedCount: $value" >&2
        exit 1
      }
    }

    assertUniqueFile() {
      local file="$1"
      local entry
      local -A seen=()
      for entry in $(<"$file"); do
        [[ -z ''${seen[$entry]-} ]] || {
          echo "$file contains a duplicate: $entry" >&2
          exit 1
        }
        seen["$entry"]=1
      done
    }

  '';
  componentOnly =
    runCommand "${cudaNamePrefix}-tests-component-hook-component-only"
      {
        __structuredAttrs = true;
        strictDeps = true;

        buildInputs = [ cuda_cudart ];
        NVCC_PREPEND_FLAGS = [
          "--library-only"
          "--untouched"
        ];
        dontCompressCudaFatbins = true;
      }
      ''
        ${assertions}

        [[ -z ''${CUDACXX-} ]]
        [[ -z ''${CUDAHOSTCXX-} ]]
        [[ -z ''${NVCC_CCBIN-} ]]
        [[ -z ''${CUDAToolkit_ROOT-} ]]
        # A library dependency must not configure NVCC or rewrite its flags.
        [[ -z ''${NIX_CUDA_DONT_COMPRESS_FATBINS-} ]]
        [[ ''${#NVCC_PREPEND_FLAGS[@]} == 2 ]]
        [[ ''${NVCC_PREPEND_FLAGS[1]} == --untouched ]]
        assertListContains " " NIX_CFLAGS_COMPILE "${cudartInclude}/include"
        assertListContains " " NIX_LDFLAGS "-L${cudartLib}/lib"

        # The runtime SDK must be usable without an NVCC dependency, including
        # the CRT headers that CUDA 12 bundles in its compiler archive.
        cat > runtime.cpp <<'EOF'
        #include <cuda_runtime.h>
        int main() {
          int version;
          return cudaRuntimeGetVersion(&version) == cudaSuccess ? 0 : 1;
        }
        EOF
        "$CXX" runtime.cpp -lcudart -o runtime

        touch "$out"
      '';
  plainConsumer = backendStdenv.mkDerivation {
    name = "${cudaNamePrefix}-tests-component-hook-plain-consumer";
    dontUnpack = true;
    strictDeps = true;
    buildInputs = [ cuda_cudart ];
    installPhase = "mkdir $out";
  };
  consumerNotComponent =
    runCommand "${cudaNamePrefix}-tests-component-hook-consumer-not-component" { }
      ''
        [[ ! -e "${plainConsumer}/nix-support/cuda-component" ]]
        [[ ! -e "${plainConsumer}/nix-support/setup-hook" ]]
        touch "$out"
      '';
  callerOverrides =
    runCommand "${cudaNamePrefix}-tests-component-hook-caller-overrides"
      {
        __structuredAttrs = true;
        strictDeps = true;

        nativeBuildInputs = [ cuda_nvcc ];

        env = {
          CUDACXX = "/caller/cuda-compiler";
          CUDAHOSTCXX = "/caller/host-compiler";
          CUDAToolkit_ROOT = "/caller/cuda-root";
          CUDA_BIN_PATH = "/caller/cuda-bin";
        };
        NVCC_PREPEND_FLAGS = [ "--caller-flag" ];
        dontCompressCudaFatbins = true;
      }
      ''
        ${assertions}

        assertEqual CUDACXX "/caller/cuda-compiler"
        assertEqual CUDAHOSTCXX "/caller/host-compiler"
        assertEqual NVCC_CCBIN "/caller/host-compiler"
        assertEqual CUDAToolkit_ROOT "/caller/cuda-root"
        assertEqual CUDA_BIN_PATH "/caller/cuda-bin"
        assertEqual NIX_CUDA_COMPILER "${getExe buildNvcc}"
        [[ "$(declare -p NVCC_PREPEND_FLAGS)" == "declare -x "* ]]
        [[ "$NVCC_PREPEND_FLAGS" == "--caller-flag" ]]
        [[ "$NVCC_PREPEND_FLAGS" != *"-Xfatbin=-compress-all"* ]]
        assertEqual NIX_CUDA_DONT_COMPRESS_FATBINS 1

        touch "$out"
      '';
  nvccCcbinOverride =
    runCommand "${cudaNamePrefix}-tests-component-hook-nvcc-ccbin-override"
      {
        __structuredAttrs = true;
        strictDeps = true;

        nativeBuildInputs = [ cuda_nvcc ];
        env.NVCC_CCBIN = "/caller/host-compiler";
      }
      ''
        ${assertions}

        assertEqual CUDAHOSTCXX "/caller/host-compiler"
        assertEqual NVCC_CCBIN "/caller/host-compiler"

        touch "$out"
      '';
  nonStrict =
    runCommand "${cudaNamePrefix}-tests-component-hook-non-strict"
      {
        nativeBuildInputs = [ cuda_nvcc ];
        buildInputs = [ cuda_cudart ];
      }
      ''
        ${assertions}

        assertEqual CUDACXX "${getExe buildNvcc}"
        assertEqual NVCC_CCBIN "${backendStdenv.cc}/bin/${backendStdenv.cc.targetPrefix}c++"

        # Non-strict environments flatten dependency roles and collect each
        # dependency once, even though stdenv invokes every registered hook.
        for collectionKey in "''${!_cudaCollectedDependencies[@]}"; do
          [[ "$collectionKey" == /nix/store/* ]]
        done
        [[ "''${_cudaComponentRegistry["*:*:cuda_nvcc:out"]-}" == "${buildNvcc}" ]]
        [[ "''${_cudaComponentRegistry["*:*:cuda_cudart:out"]-}" == "${cuda_cudart}" ]]

        touch "$out"
      '';
  nonStrictPropagationProducer =
    runCommand "${cudaNamePrefix}-tests-component-hook-non-strict-propagation-producer"
      {
        outputs = [
          "out"
          "cxxdev"
        ];
        depsBuildBuild = [ cuda_cudart ];
        nativeBuildInputs = [
          cuda_nvcc
          cuda_cudart
        ];
        depsBuildTarget = [ cuda_cudart ];
        depsHostHost = [ cuda_cudart ];
        buildInputs = [ cuda_cudart ];
        depsTargetTarget = [ cuda_cudart ];
        cudaPropagateDependenciesToOutput = "cxxdev";
      }
      ''
        touch "$out"
        mkdir "$cxxdev"
        runHook postFixup
      '';
  nonStrictPropagation =
    runCommand "${cudaNamePrefix}-tests-component-hook-non-strict-propagation"
      {
        __structuredAttrs = true;
        strictDeps = true;

        buildInputs = [ nonStrictPropagationProducer.cxxdev ];
      }
      ''
        ${assertions}

        # Environment-hook roles are flattened without strictDeps, but
        # propagation follows setup.sh's dependency graph and remains exact.
        for propagationFile in \
          propagated-build-build-deps \
          propagated-native-build-inputs \
          propagated-build-target-deps \
          propagated-host-host-deps \
          propagated-build-inputs \
          propagated-target-target-deps
        do
          propagatedInputs="$(<"${nonStrictPropagationProducer.cxxdev}/nix-support/$propagationFile")"
          assertListContains " " propagatedInputs "${cuda_cudart}"
        done
        [[ -n ''${_cudaCollectedDependencies["0:0:${cuda_cudart}"]-} ]]
        [[ -n ''${_cudaCollectedDependencies["0:1:${cuda_cudart}"]-} ]]

        touch "$out"
      '';
  propagationProducer =
    runCommand "${cudaNamePrefix}-tests-component-hook-propagation-producer"
      {
        __structuredAttrs = true;
        strictDeps = true;

        outputs = [
          "out"
          "dev"
          "cxxdev"
        ];
        depsBuildBuild = [ cuda_cudart ];
        nativeBuildInputs = [
          cuda_nvcc
          cuda_cudart
        ];
        depsBuildTarget = [ cuda_cudart ];
        depsHostHost = [
          cuda_cudart
          inactiveCompiler
        ];
        buildInputs = [
          cuda_cudart
          inactiveCompiler
        ];
        depsTargetTarget = [ cuda_cudart ];
        cudaPropagateDependenciesToOutput = "cxxdev";
      }
      ''
        touch "$out"
        mkdir "$dev"
        mkdir -p "$cxxdev/nix-support"
        printWords \
          "${plainDependency}" \
          "${inactiveCompiler}" \
          "${cuda_cudart}" \
          "${inactiveCompiler}" \
          >"$cxxdev/nix-support/propagated-build-inputs"
        runHook postFixup
      '';
  propagation =
    runCommand "${cudaNamePrefix}-tests-component-hook-propagation"
      {
        __structuredAttrs = true;
        strictDeps = true;

        buildInputs = [ propagationProducer.cxxdev ];
      }
      ''
        ${assertions}

        for propagationFile in \
          propagated-build-build-deps \
          propagated-native-build-inputs \
          propagated-build-target-deps \
          propagated-host-host-deps \
          propagated-build-inputs \
          propagated-target-target-deps
        do
          propagatedInputs="$(<"${propagationProducer.cxxdev}/nix-support/$propagationFile")"
          assertListContains " " propagatedInputs "${cuda_cudart}"
          assertUniqueFile "${propagationProducer.cxxdev}/nix-support/$propagationFile"
        done

        _propagatedBuildHost="$(<"${propagationProducer.cxxdev}/nix-support/propagated-native-build-inputs")"
        _propagatedHostHost="$(<"${propagationProducer.cxxdev}/nix-support/propagated-host-host-deps")"
        _propagatedHostTarget="$(<"${propagationProducer.cxxdev}/nix-support/propagated-build-inputs")"

        assertListContains " " _propagatedBuildHost "${buildNvcc}"
        assertListContains " " _propagatedHostTarget "${propagationProducer.dev}"
        assertListCount " " _propagatedHostTarget "${propagationProducer.out}" 0
        assertListCount " " _propagatedHostTarget "${plainDependency}" 1
        [[ "''${CUDACXX-}" == "${getExe buildNvcc}" ]]
        assertEqual NVCC_CCBIN "${backendStdenv.cc}/bin/${backendStdenv.cc.targetPrefix}c++"
        assertListContains ";" CUDAToolkit_ROOT "${buildNvcc}"
        assertListContains " " _propagatedHostHost "${cuda_cudart}"
        assertListContains " " _propagatedHostHost "${inactiveCompiler}"
        assertListContains " " _propagatedHostTarget "${cuda_cudart}"
        assertListContains " " _propagatedHostTarget "${inactiveCompiler}"
        [[ -n ''${_cudaCollectedDependencies["0:0:${cuda_cudart}"]-} ]]
        [[ -n ''${_cudaCollectedDependencies["0:1:${cuda_cudart}"]-} ]]
        [[ -n ''${_cudaCollectedDependencies["0:0:${inactiveCompiler}"]-} ]]
        [[ -n ''${_cudaCollectedDependencies["0:1:${inactiveCompiler}"]-} ]]
        [[ "''${_cudaComponentRegistry["0:0:inactive_nvcc:out"]-}" == "${inactiveCompiler}" ]]
        [[ "''${_cudaComponentRegistry["0:1:inactive_nvcc:out"]-}" == "${inactiveCompiler}" ]]
        touch "$out"
      '';
  # PATH precedence must survive propagation, even when the caller's order
  # is the opposite of lexicographic store-path order.
  orderedChoices = lib.sort (a: b: toString a > toString b) [
    (writeShellScriptBin "cuda-propagation-choice" "echo first")
    (writeShellScriptBin "cuda-propagation-choice" "echo second")
  ];
  orderedProducer =
    runCommand "${cudaNamePrefix}-ordered-propagation-producer"
      {
        outputs = [
          "out"
          "cxxdev"
        ];
        strictDeps = true;
        nativeBuildInputs = [ cudaComponentHook ];
        cudaPropagateDependenciesToOutput = "cxxdev";
      }
      ''
        mkdir -p "$out" "$cxxdev/nix-support"
        printWords ${lib.escapeShellArgs orderedChoices} > "$cxxdev/nix-support/propagated-native-build-inputs"
        runHook postFixup
      '';
  orderedPropagation =
    runCommand "${cudaNamePrefix}-ordered-propagation"
      {
        strictDeps = true;
        buildInputs = [ orderedProducer.cxxdev ];
      }
      ''
        test "$(command -v cuda-propagation-choice)" = "${lib.getExe' (builtins.head orderedChoices) "cuda-propagation-choice"}"
        touch "$out"
      '';
  aggregate =
    runCommand "${cudaNamePrefix}-tests-component-hook-aggregate"
      {
        __structuredAttrs = true;
        strictDeps = true;

        nativeBuildInputs = [ cudatoolkit ];
      }
      ''
        ${assertions}

        assertEqual CUDACXX "${getExe buildNvcc}"
        assertListContains ";" CUDAToolkit_ROOT "${buildNvcc}"

        touch "$out"
      '';
in
runCommand "${cudaNamePrefix}-tests-component-hook"
  {
    __structuredAttrs = true;
    strictDeps = true;

    nativeBuildInputs = [
      cuda_nvcc
      cuda_cudart
    ];
    depsBuildBuild = [
      cuda_nvcc
      cuda_cudart
    ];
    depsBuildTarget = [
      cuda_nvcc
      cuda_cudart
    ];
    depsHostHost = [
      inactiveCompiler
      cuda_cudart
    ];
    buildInputs = [
      inactiveCompiler
      cuda_cudart
      # Its dev output has no archive payload. buildRedist must create it
      # before the runpath fixup hooks inspect every declared output.
      cuda_profiler_api
      setupHookComponent
    ];
    depsTargetTarget = [
      inactiveCompiler
      cuda_cudart
    ];

    passthru.tests = {
      inherit
        aggregate
        callerOverrides
        nonStrict
        nonStrictPropagation
        orderedPropagation
        ;
      component-only = componentOnly;
      consumer-not-component = consumerNotComponent;
      duplicate-component = duplicateComponent;
      incompatible-versions = incompatibleVersions;
      invalid-compiler = invalidCompilerTest;
      nvcc-ccbin-override = nvccCcbinOverride;
      inherit propagation;
    };
  }
  ''
    ${assertions}

    assertComponentMetadata() {
      local metadataPath="$1/nix-support/cuda-component"
      local expectedComponent="$2"
      local expectedOutput="$3"
      local expectedVersion="$4"
      local -A cudaComponentMetadata=()
      source "$metadataPath"

      [[ "''${cudaComponentMetadata[format]-}" == 3 ]]
      [[ "''${cudaComponentMetadata[component]-}" == "$expectedComponent" ]]
      [[ "''${cudaComponentMetadata[output]-}" == "$expectedOutput" ]]
      [[ "''${cudaComponentMetadata[cudaMajorMinorVersion]-}" == "${cudaMajorMinorVersion}" ]]
      [[ "''${cudaComponentMetadata[cudaComponentVersion]-}" == "$expectedVersion" ]]
    }

    assertCompilerMetadata() {
      local metadataPath="$1/nix-support/cuda-component"
      local -A cudaComponentMetadata=()
      source "$metadataPath"

      [[ "''${cudaComponentMetadata[compiler]-}" == "bin/nvcc" ]]
    }

    assertComponentSetupHook() {
      local setupHook="$1/nix-support/setup-hook"
      local collectorStatement="source $2/nix-support/setup-hook"
      local firstStatement=
      IFS= read -r firstStatement <"$setupHook"

      [[ "$firstStatement" == "$collectorStatement" ]]
      [[ "$(grep -Fxc "$collectorStatement" "$setupHook")" == 1 ]]
    }

    assertEqual CUDACXX "${getExe buildNvcc}"
    assertEqual NVCC_CCBIN "${backendStdenv.cc}/bin/${backendStdenv.cc.targetPrefix}c++"
    assertEqual NIX_CUDA_COMPILER "${getExe buildNvcc}"
    assertEqual NIX_CUDA_COMPILER_ROOT "${buildNvcc}"
    assertEqual NIX_CUDA_MAJOR_MINOR_VERSION "${cudaMajorMinorVersion}"
    assertEqual NIX_CUDA_COMPILER_FOR_BUILD "${getExe buildBuildNvcc}"
    assertEqual NIX_CUDA_COMPILER_ROOT_FOR_BUILD "${buildBuildNvcc}"
    assertEqual NIX_CUDA_COMPILER_FOR_TARGET "${getExe buildTargetNvcc}"
    assertEqual NIX_CUDA_COMPILER_ROOT_FOR_TARGET "${buildTargetNvcc}"

    assertComponentMetadata "${buildNvcc}" cuda_nvcc out "${cuda_nvcc.version}"
    assertComponentMetadata "${cuda_cudart}" cuda_cudart out "${cuda_cudart.version}"
    assertComponentMetadata "${setupHookComponent}" existing_setup_hook out 1
    assertComponentMetadata "${setupHookComponent.dev}" existing_setup_hook dev 1
    assertComponentMetadata "${cuda_profiler_api.dev}" cuda_profiler_api dev "${cuda_profiler_api.version}"
    assertComponentMetadata "${cuda_profiler_api.include}" cuda_profiler_api include "${cuda_profiler_api.version}"
    assertCompilerMetadata "${buildNvcc}"
    # buildRedist embeds its own scope's collector; the test component uses
    # nativeBuildInputs, which selects the BUILD collector automatically.
    assertComponentSetupHook "${buildNvcc}" "${buildComponentHook}"
    assertComponentSetupHook "${cuda_cudart}" "${cudaComponentHook}"
    assertComponentSetupHook "${cuda_profiler_api.dev}" "${cudaComponentHook}"
    assertComponentSetupHook "${cuda_profiler_api.include}" "${cudaComponentHook}"
    assertComponentSetupHook "${setupHookComponent}" "${buildComponentHook}"
    assertComponentSetupHook "${setupHookComponent.dev}" "${buildComponentHook}"
    grep -Fqx \
      'export CUDA_COMPONENT_EXISTING_SETUP_HOOK=preserved' \
      "${setupHookComponent.dev}/nix-support/setup-hook"
    assertEqual CUDA_COMPONENT_EXISTING_SETUP_HOOK preserved

    assertListContains " " NIX_CFLAGS_COMPILE_FOR_BUILD "${getOutput buildCudart.outputInclude buildCudart}/include"
    assertListContains " " NIX_CFLAGS_COMPILE "${cudartInclude}/include"
    assertListContains " " NIX_CFLAGS_COMPILE_FOR_TARGET "${getOutput targetCudart.outputInclude targetCudart}/include"
    assertListContains " " NIX_LDFLAGS_FOR_BUILD "-L${getOutput "lib" buildCudart}/lib"
    assertListContains " " NIX_LDFLAGS "-L${cudartLib}/lib"
    assertListContains " " NIX_LDFLAGS_FOR_TARGET "-L${getOutput "lib" targetCudart}/lib"

    # Compiler providers that cannot execute on BUILD remain registered for
    # runtime/JIT discovery, but must not be selected as build-time compilers.
    [[ "''${NIX_CUDA_COMPILER-}" == "${getExe buildNvcc}" ]]

    # All six dependency pairs were visited. Libraries project by host role;
    # executable compiler providers are activated only for BUILD-hosted pairs.
    ${lib.concatMapStrings (
      {
        splice,
        offsets,
        compiler,
      }:
      let
        component = cuda_cudart.__spliced.${splice} or cuda_cudart;
        compilerPackage = if compiler then cuda_nvcc.__spliced.${splice} or cuda_nvcc else inactiveCompiler;
        compilerName = if compiler then "cuda_nvcc" else "inactive_nvcc";
      in
      ''
        [[ -n ''${_cudaCollectedDependencies["${offsets}:${component}"]-} ]]
        [[ "''${_cudaComponentRegistry["${offsets}:cuda_cudart:out"]-}" == "${component}" ]]
        [[ -n ''${_cudaCollectedDependencies["${offsets}:${compilerPackage}"]-} ]]
        [[ "''${_cudaComponentRegistry["${offsets}:${compilerName}:out"]-}" == "${compilerPackage}" ]]
      ''
    ) dependencyRoles}
    [[ "''${_cudaComponentRegistry["0:1:existing_setup_hook:out"]-}" == "${setupHookComponent}" ]]
    [[ "''${_cudaComponentRegistry["0:1:existing_setup_hook:dev"]-}" == "${setupHookComponent.dev}" ]]

    assertEqual CUDAToolkit_ROOT "${buildNvcc}"
    # Automatic flags belong to the invoked wrapper, not a global environment
    # that would leak HOST headers into BUILD compiler invocations.
    assertEqual NVCC_PREPEND_FLAGS ""

    touch "$out"
  ''
