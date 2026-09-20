{
  backendCC,
  buildPackages,
  clangStdenv,
  cudaConfig,
  cudaNamePrefix,
  cuda_nvcc,
  lib,
  makeSetupHook,
  replaceVars,
  stdenvNoCC,
  withDefaultHardeningFlags,
  writeText,
  writeTextDir,
  zlib,
  nvccSetupHook ? ../cuda_nvcc/setup-hook.sh,
}:
let
  nvcc = cuda_nvcc.__spliced.buildHost or cuda_nvcc;
  cc = backendCC.__spliced.buildHost or backendCC;
  bintools = cc.bintools;
  bintoolsSalt = bintools.suffixSalt or bintools.env.suffixSalt;
  arch = lib.replaceStrings [ "." ] [ "" ] (lib.head cudaConfig.cudaCapabilities);
  fortranHook = replaceVars ../../../../build-support/cc-wrapper/fortran-hook.sh {
    named_fc = "backend-fortran";
    default_hardening_flags_str = "";
  };

  # Keep the actual standard callbacks, adding effects a backend may acquire
  # without NVCC knowing its complete inventory of tools or scratch variables.
  backend = writeTextDir "nix-support/setup-hook" ''
    source ${cc}/nix-support/setup-hook
    source ${fortranHook}
    export FUTURE_BACKEND_TOOL=backend-tool
    export NVCC_TEST_UNSET_TOOL=backend-only
    export PATH="/backend-only:$PATH"
    export _PATH="/backend-only:$_PATH"
    echo 'backend diagnostic on stdout; this must not become shell code'
  '';
  setup = replaceVars nvccSetupHook {
    nvccPrefix = lib.getBin nvcc;
    cc = backend;
    inherit bintools;
    hostCompiler = "${cc}/bin/${cc.targetPrefix}c++";
  };
  toolVariables = [
    "CC"
    "CXX"
    "FC"
    "AR"
    "LD"
    "NIX_CC"
    "NIX_BINTOOLS"
    "FUTURE_BACKEND_TOOL"
  ]
  ++
    lib.concatMap
      (role: [
        "NIX_CC_WRAPPER_TARGET_${role}_${cc.suffixSalt}"
        "NIX_BINTOOLS_WRAPPER_TARGET_${role}_${bintoolsSalt}"
      ])
      [
        "BUILD"
        "HOST"
        "TARGET"
      ];
  hook = makeSetupHook { name = "${cudaNamePrefix}-nvcc-hook-containment"; } (
    writeText "nvcc-hook-containment.sh" ''
      declare -A nvccHookExpected=()
      for variable in ${lib.escapeShellArgs toolVariables}; do
        export "$variable=enclosing-$variable"
      done
      for variable in PATH _PATH ${lib.escapeShellArgs toolVariables}; do
        nvccHookExpected[$variable]="$(declare -p "$variable" 2>/dev/null || true)"
      done
      source ${setup}
      for variable in "''${!nvccHookExpected[@]}"; do
        if [[ $(declare -p "$variable" 2>/dev/null || true) != "''${nvccHookExpected[$variable]}" ]]; then
          echo "NVCC backend changed enclosing $variable: ''${!variable-}" >&2
          exit 1
        fi
      done
      if [[ -v NVCC_TEST_UNSET_TOOL ]]; then
        echo 'NVCC backend exported an unrelated tool into the project' >&2
        exit 1
      fi
      unset nvccHookExpected variable
    ''
  );
  dependencyHeader = writeTextDir "include/nvcc-collector-origin.h" ''
    static const char* collectorOrigin(void) { return __FILE__; }
  '';
  # Clang's collector scrubs __FILE__ references; GCC's uses its compiler
  # patch instead. Activation of either must preserve the other's callbacks.
  collectorIdentity =
    forTarget:
    clangStdenv.mkDerivation {
      name = "${cudaNamePrefix}-tests-nvcc-hook-identity-${if forTarget then "target" else "host"}";
      strictDeps = true;
      nativeBuildInputs = lib.optional (!forTarget) cuda_nvcc;
      depsBuildTarget = lib.optional forTarget cuda_nvcc;
      buildInputs = [ dependencyHeader ];
      depsTargetTarget = lib.optional forTarget dependencyHeader;
      disallowedReferences = [ dependencyHeader ];
      buildCommand = ''
        [[ $NIX_CFLAGS_COMPILE == *'-fmacro-prefix-map=${dependencyHeader}='* ]]
        ${lib.optionalString forTarget ''
          [[ $NIX_CFLAGS_COMPILE_FOR_TARGET == *'${dependencyHeader}/include'* ]]
          [[ $NIX_CFLAGS_COMPILE_FOR_TARGET != *'-fmacro-prefix-map=${dependencyHeader}='* ]]
        ''}
        cat > origin.c <<'C'
        #include <nvcc-collector-origin.h>
        const char* origin(void) { return collectorOrigin(); }
        C
        mkdir "$out"
        "$CC" -shared -fPIC origin.c -o "$out/liborigin.so"
      '';
    };
  # Standard compiler defaults are chosen during dependency activation.
  # NVCC must not populate the global default before that compiler does.
  hardeningDefault = (withDefaultHardeningFlags [ ] clangStdenv).mkDerivation {
    name = "${cudaNamePrefix}-tests-nvcc-hook-hardening-default";
    strictDeps = true;
    nativeBuildInputs = [ cuda_nvcc ];
    buildCommand = ''
      test -z "$NIX_HARDENING_ENABLE"
      cat > hardening.c <<'C'
      #ifdef _FORTIFY_SOURCE
      #error NVCC replaced the ordinary compiler's hardening default
      #endif
      int main(void) { return 0; }
      C
      mkdir "$out"
      "$CC" -O2 hardening.c -o "$out/probe"
    '';
  };
  hardeningOverride =
    explicitDisable:
    stdenvNoCC.mkDerivation {
      name = "${cudaNamePrefix}-tests-nvcc-hook-hardening-${
        if explicitDisable then "disable" else "post-hook"
      }";
      strictDeps = true;
      nativeBuildInputs = [ cuda_nvcc ];
      hardeningDisable = lib.optional explicitDisable "all";
      # The implicit postHook precedes the postHooks array. Its assignment
      # must retain its value and acquire the ordinary wrapper's export.
      postHook = lib.optionalString (!explicitDisable) ''
        NIX_HARDENING_ENABLE=pic
      '';
      buildCommand = ''
        test "$(printenv NIX_HARDENING_ENABLE)" = '${lib.optionalString (!explicitDisable) "pic"}'
        mkdir "$out"
      '';
    };
  backendLibrary = stdenvNoCC.mkDerivation {
    name = "${cudaNamePrefix}-tests-nvcc-backend-default-library";
    nativeBuildInputs = [ cc ];
    buildCommand = ''
      echo 'int backendDefault(void) { return 42; }' > library.c
      "$CC" -c -fPIC library.c -o library.o
      mkdir -p "$out/lib"
      "$AR" cr "$out/lib/libbackend-default.a" library.o
    '';
  };
  # Functions are not spliced. Construct the executable wrapper in its BUILD
  # package set, while the compiler, bintools and stdenv retain its target.
  alternateBackend = buildPackages.wrapCCWith {
    stdenvNoCC = cc.stdenv;
    inherit (cc)
      cc
      nativeTools
      nativeLibc
      nativePrefix
      ;
    bintools = bintools.override {
      extraBuildCommands = ''
        echo ' -L${backendLibrary}/lib' >> "$out/nix-support/libc-ldflags"
      '';
    };
  };
  backendDefaults = stdenvNoCC.mkDerivation {
    name = "${cudaNamePrefix}-tests-nvcc-hook-backend-defaults";
    strictDeps = true;
    nativeBuildInputs = [ cuda_nvcc ];
    buildCommand = ''
      cat > main.cc <<'C'
      extern "C" int backendDefault(void);
      int main(void) { return backendDefault() != 42; }
      C
      mkdir "$out"
      # The library is deliberately absent from buildInputs. Only this
      # alternative standard backend's own bintools defaults can find it.
      ${alternateBackend}/bin/${alternateBackend.targetPrefix}c++ \
        main.cc -lbackend-default -o "$out/direct"
      NVCC_CCBIN=${alternateBackend}/bin/${alternateBackend.targetPrefix}c++ \
        ${lib.getExe nvcc} -arch=sm_${arch} --cudart=shared \
        main.cc -lbackend-default -o "$out/nvcc"
    '';
  };
in
stdenvNoCC.mkDerivation {
  name = "${cudaNamePrefix}-tests-nvcc-hook";
  strictDeps = true;
  # No ordinary compiler hook may supply the collectors this test exercises.
  nativeBuildInputs = [ hook ];
  buildInputs = [ zlib ];
  passthru.tests = {
    hardening-default = hardeningDefault;
    hardening-disable = hardeningOverride true;
    hardening-post-hook = hardeningOverride false;
  }
  // lib.optionalAttrs cc.isGNU {
    # The ordinary stdenv compiler activates after nativeBuildInputs but
    # before depsBuildTarget, exercising both callback-definition orders.
    collector-identity-host = collectorIdentity false;
    collector-identity-target = collectorIdentity true;
    backend-defaults = backendDefaults;
  };
  buildCommand = ''
    test "$NIX_HARDENING_ENABLE" = ${lib.escapeShellArg (toString cc.defaultHardeningFlags)}
    [[ $NIX_CFLAGS_COMPILE == *'${lib.getDev zlib}/include'* ]]
    [[ $NIX_LDFLAGS == *'-L${lib.getLib zlib}/lib'* ]]
    cat > probe.cu <<'CUDA'
    #include <zlib.h>
    extern "C" const char* dependencyVersion() { return zlibVersion(); }
    __global__ void probe(int* value) { *value = 42; }
    CUDA
    # Activation also sets CUDAHOSTCXX for CMake. A later direct NVCC override
    # must still reach the chosen backend, and an explicit -ccbin must win.
    mkdir backend-override
    cat > backend-override/c++ <<'SH'
    #!${stdenvNoCC.shell}
    printf '%s\n' "$@" >> "$NVCC_TEST_BACKEND_LOG"
    exec ${cc}/bin/${cc.targetPrefix}c++ "$@"
    SH
    chmod +x backend-override/c++
    export NVCC_TEST_BACKEND_LOG="$PWD/backend.log"
    NVCC_CCBIN="$PWD/backend-override/c++" \
      ${lib.getExe nvcc} -arch=sm_${arch} -E probe.cu -o /dev/null
    if [[ ! -s $NVCC_TEST_BACKEND_LOG ]]; then
      echo 'NVCC ignored the backend override after activation' >&2
      exit 1
    fi
    rm "$NVCC_TEST_BACKEND_LOG"
    NVCC_CCBIN=c++ PATH="$PWD/backend-override:$PATH" \
      ${lib.getExe nvcc} -arch=sm_${arch} -E probe.cu -o /dev/null
    if [[ ! -s $NVCC_TEST_BACKEND_LOG ]]; then
      echo 'NVCC ignored the backend override on the caller PATH' >&2
      exit 1
    fi
    rm "$NVCC_TEST_BACKEND_LOG"
    # Use a name also present in the packaged backend. An unrelated alias
    # would conceal the default backend shadowing the caller's PATH.
    PATH="$PWD/backend-override:$PATH" \
      ${lib.getExe nvcc} -ccbin c++ -arch=sm_${arch} -E probe.cu -o /dev/null
    test -s "$NVCC_TEST_BACKEND_LOG"
    rm "$NVCC_TEST_BACKEND_LOG"
    for variable in NVCC_PREPEND_FLAGS NVCC_APPEND_FLAGS; do
      env "$variable=-ccbin c++" PATH="$PWD/backend-override:$PATH" \
        ${lib.getExe nvcc} -arch=sm_${arch} -E probe.cu -o /dev/null
      test -s "$NVCC_TEST_BACKEND_LOG"
      rm "$NVCC_TEST_BACKEND_LOG"
    done
    NVCC_CCBIN=/missing-backend \
      ${lib.getExe nvcc} -ccbin "$PWD/backend-override/c++" -arch=sm_${arch} -E probe.cu -o /dev/null
    test -s "$NVCC_TEST_BACKEND_LOG"

    mkdir -p "$out/lib"
    ${lib.getExe nvcc} -shared -arch=sm_${arch} -Xcompiler=-fPIC \
      --cudart=shared probe.cu -lz -o "$out/lib/probe.so"
    ${bintools}/bin/${cc.targetPrefix}readelf -d "$out/lib/probe.so" \
      | grep 'Shared library: \[libz.so.1\]'
  '';
}
