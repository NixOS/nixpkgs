{
  backendStdenv,
  cuda_cudart,
  cudaComponentHook,
  cudaMajorMinorVersion,
  cuda_nvcc,
  cudaNamePrefix,
  cudatoolkit,
  lib,
  testers,
}:
let
  inherit (lib) getExe getOutput;
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
  cudartInclude = getOutput "include" cuda_cudart;
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
  setupHookComponent = mkTestComponent {
    componentName = "existing_setup_hook";
    inherit cudaMajorMinorVersion;
    install = ''
      mkdir -p "$out/nix-support"
      echo 'export CUDA_COMPONENT_EXISTING_SETUP_HOOK=preserved' >"$out/nix-support/setup-hook"
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
    expectedHostCompiler="${backendStdenv.cc}/bin/${backendStdenv.cc.targetPrefix}c++"

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
      local entry
      local count=0
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

    assertSortedUniqueFile() {
      local file="$1"
      local LC_ALL=C
      local previous=
      local entry

      for entry in $(<"$file"); do
        if [[ -n "$previous" && ! "$previous" < "$entry" ]]; then
          echo "$file is not sorted and unique: $previous then $entry" >&2
          exit 1
        fi
        previous="$entry"
      done
    }
  '';
  componentOnly =
    runCommand "${cudaNamePrefix}-tests-component-hook-component-only"
      {
        __structuredAttrs = true;
        strictDeps = true;

        buildInputs = [ cuda_cudart ];
      }
      ''
        ${assertions}

        [[ -z ''${CUDACXX-} ]]
        [[ -z ''${CUDAHOSTCXX-} ]]
        [[ -z ''${NVCC_CCBIN-} ]]
        [[ -z ''${CUDAToolkit_ROOT-} ]]
        assertListContains ";" NIX_CUDA_COMPONENT_PATH "${cuda_cudart}"
        assertListContains ":" NIX_CUDA_INCLUDE_PATH "${cudartInclude}/include"
        assertListContains ":" NIX_CUDA_LIBRARY_PATH "${cudartLib}/lib"

        touch "$out"
      '';
  consumerNotComponent =
    runCommand "${cudaNamePrefix}-tests-component-hook-consumer-not-component" { }
      ''
        [[ ! -e "${componentOnly}/nix-support/cuda-component" ]]
        [[ ! -e "${componentOnly}/nix-support/setup-hook" ]]
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
        assertEqual NIX_CUDA_COMPILER "${getExe cuda_nvcc}"
        [[ "$(declare -p NVCC_PREPEND_FLAGS)" == "declare -x "* ]]
        [[ "$NVCC_PREPEND_FLAGS" == "--caller-flag "* ]]
        [[ "$NVCC_PREPEND_FLAGS" != *"-Xfatbin=-compress-all"* ]]

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

        assertEqual CUDACXX "${getExe cuda_nvcc}"
        assertEqual CUDAHOSTCXX "$expectedHostCompiler"
        assertEqual NVCC_CCBIN "$expectedHostCompiler"
        assertListCount ";" NIX_CUDA_COMPONENT_PATH "${cuda_nvcc}" 1
        assertListCount ";" NIX_CUDA_COMPONENT_PATH "${cuda_cudart}" 1

        # Non-strict environments flatten dependency roles and collect each
        # dependency once, even though stdenv invokes every registered hook.
        for collectionKey in "''${!_cudaCollectedDependencies[@]}"; do
          [[ "$collectionKey" == /nix/store/* ]]
        done
        [[ "''${_cudaComponentRegistry["*:*:cuda_nvcc:out"]-}" == "${cuda_nvcc}" ]]
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
          assertSortedUniqueFile "${propagationProducer.cxxdev}/nix-support/$propagationFile"
        done

        _propagatedBuildHost="$(<"${propagationProducer.cxxdev}/nix-support/propagated-native-build-inputs")"
        _propagatedHostHost="$(<"${propagationProducer.cxxdev}/nix-support/propagated-host-host-deps")"
        _propagatedHostTarget="$(<"${propagationProducer.cxxdev}/nix-support/propagated-build-inputs")"

        assertListContains " " _propagatedBuildHost "${cuda_nvcc}"
        assertListContains " " _propagatedHostTarget "${propagationProducer.dev}"
        assertListCount " " _propagatedHostTarget "${propagationProducer.out}" 0
        assertListCount " " _propagatedHostTarget "${plainDependency}" 1
        [[ "''${CUDACXX-}" == "${getExe cuda_nvcc}" ]]
        [[ "''${CUDAHOSTCXX-}" == "$expectedHostCompiler" ]]
        [[ "''${NVCC_CCBIN-}" == "$expectedHostCompiler" ]]
        assertListContains ";" NIX_CUDA_COMPONENT_PATH "${cuda_cudart}"
        assertListContains ";" CUDAToolkit_ROOT "${cuda_nvcc}"
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
  aggregate =
    runCommand "${cudaNamePrefix}-tests-component-hook-aggregate"
      {
        __structuredAttrs = true;
        strictDeps = true;

        buildInputs = [ cudatoolkit ];
      }
      ''
        ${assertions}

        assertEqual CUDACXX "${getExe cuda_nvcc}"
        assertEqual CUDAHOSTCXX "$expectedHostCompiler"
        assertListContains ";" NIX_CUDA_COMPONENT_PATH "${cuda_nvcc}"
        assertListContains ";" NIX_CUDA_COMPONENT_PATH "${cuda_cudart}"
        assertListContains ";" CUDAToolkit_ROOT "${cuda_nvcc}"

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
      [[ "''${cudaComponentMetadata[hostCompiler]-}" == "$expectedHostCompiler" ]]
    }

    assertComponentSetupHook() {
      local setupHook="$1/nix-support/setup-hook"
      local collectorStatement="source ${cudaComponentHook}/nix-support/setup-hook"
      local firstStatement=
      IFS= read -r firstStatement <"$setupHook"

      [[ "$firstStatement" == "$collectorStatement" ]]
      [[ "$(grep -Fxc "$collectorStatement" "$setupHook")" == 1 ]]
    }

    assertEqual CUDACXX "${getExe cuda_nvcc}"
    assertEqual CUDAHOSTCXX "$expectedHostCompiler"
    assertEqual NVCC_CCBIN "$expectedHostCompiler"
    assertEqual NIX_CUDA_COMPILER "${getExe cuda_nvcc}"
    assertEqual NIX_CUDA_COMPILER_ROOT "${cuda_nvcc}"
    assertEqual NIX_CUDA_MAJOR_MINOR_VERSION "${cudaMajorMinorVersion}"
    assertEqual NIX_CUDA_COMPILER_FOR_BUILD "${getExe cuda_nvcc}"
    assertEqual NIX_CUDA_COMPILER_ROOT_FOR_BUILD "${cuda_nvcc}"
    assertEqual NIX_CUDA_COMPILER_FOR_TARGET "${getExe cuda_nvcc}"
    assertEqual NIX_CUDA_COMPILER_ROOT_FOR_TARGET "${cuda_nvcc}"

    assertComponentMetadata "${cuda_nvcc}" cuda_nvcc out "${cuda_nvcc.version}"
    assertComponentMetadata "${cuda_cudart}" cuda_cudart out "${cuda_cudart.version}"
    assertComponentMetadata "${setupHookComponent}" existing_setup_hook out 1
    assertCompilerMetadata "${cuda_nvcc}"
    assertComponentSetupHook "${cuda_nvcc}"
    assertComponentSetupHook "${cuda_cudart}"
    assertComponentSetupHook "${setupHookComponent}"
    grep -Fqx \
      'export CUDA_COMPONENT_EXISTING_SETUP_HOOK=preserved' \
      "${setupHookComponent}/nix-support/setup-hook"
    assertEqual CUDA_COMPONENT_EXISTING_SETUP_HOOK preserved

    assertListContains ";" NIX_CUDA_COMPONENT_PATH "${cuda_nvcc}"
    assertListContains ";" NIX_CUDA_COMPONENT_PATH "${cuda_cudart}"
    assertListContains ";" NIX_CUDA_COMPONENT_PATH_FOR_BUILD "${cuda_nvcc}"
    assertListContains ";" NIX_CUDA_COMPONENT_PATH_FOR_BUILD "${cuda_cudart}"
    assertListContains ";" NIX_CUDA_COMPONENT_PATH_FOR_TARGET "${cuda_nvcc}"
    assertListContains ";" NIX_CUDA_COMPONENT_PATH_FOR_TARGET "${cuda_cudart}"
    assertListContains ":" NIX_CUDA_INCLUDE_PATH_FOR_BUILD "${cudartInclude}/include"
    assertListContains ":" NIX_CUDA_INCLUDE_PATH "${cudartInclude}/include"
    assertListContains ":" NIX_CUDA_INCLUDE_PATH_FOR_TARGET "${cudartInclude}/include"
    assertListContains ":" NIX_CUDA_LIBRARY_PATH_FOR_BUILD "${cudartLib}/lib"
    assertListContains ":" NIX_CUDA_LIBRARY_PATH "${cudartLib}/lib"
    assertListContains ":" NIX_CUDA_LIBRARY_PATH_FOR_TARGET "${cudartLib}/lib"
    assertListCount ";" NIX_CUDA_COMPONENT_PATH "${cuda_nvcc}" 1
    assertListCount ";" NIX_CUDA_COMPONENT_PATH "${cuda_cudart}" 1
    assertListCount ";" NIX_CUDA_COMPONENT_PATH_FOR_BUILD "${cuda_cudart}" 1
    assertListCount ";" NIX_CUDA_COMPONENT_PATH_FOR_TARGET "${cuda_cudart}" 1

    # Compiler providers that cannot execute on BUILD remain registered for
    # runtime/JIT discovery, but must not be selected as build-time compilers.
    [[ "''${NIX_CUDA_COMPILER-}" == "${getExe cuda_nvcc}" ]]

    # All six dependency pairs were visited. Libraries project by host role;
    # executable compiler providers are activated only for BUILD-hosted pairs.
    for dependencyOffsets in -1:-1 -1:0 -1:1 0:0 0:1 1:1; do
      [[ -n ''${_cudaCollectedDependencies["$dependencyOffsets:${cuda_cudart}"]-} ]]
      [[ "''${_cudaComponentRegistry["$dependencyOffsets:cuda_cudart:out"]-}" == "${cuda_cudart}" ]]
    done
    for dependencyOffsets in -1:-1 -1:0 -1:1; do
      [[ "''${_cudaComponentRegistry["$dependencyOffsets:cuda_nvcc:out"]-}" == "${cuda_nvcc}" ]]
    done
    for dependencyOffsets in 0:0 0:1 1:1; do
      [[ -n ''${_cudaCollectedDependencies["$dependencyOffsets:${inactiveCompiler}"]-} ]]
      [[ "''${_cudaComponentRegistry["$dependencyOffsets:inactive_nvcc:out"]-}" == "${inactiveCompiler}" ]]
    done
    [[ "''${_cudaComponentRegistry["0:1:existing_setup_hook:out"]-}" == "${setupHookComponent}" ]]

    assertEqual CUDAToolkit_ROOT "${cuda_nvcc}"
    [[ "''${NVCC_PREPEND_FLAGS-}" == *"-I${cudartInclude}/include"* ]]
    [[ "''${NVCC_PREPEND_FLAGS-}" == *"-Xfatbin=-compress-all"* ]]

    touch "$out"
  ''
