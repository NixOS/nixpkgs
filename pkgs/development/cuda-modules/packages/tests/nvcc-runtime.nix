{
  backendCC,
  buildPackages,
  cccl,
  cudaConfig,
  cudaMajorMinorVersion,
  cuda_cudart,
  cuda_nvcc,
  cudaNamePrefix,
  lib,
  stdenvNoCC,
}:
let
  nvcc = cuda_nvcc.__spliced.buildHost or cuda_nvcc;
  cc = backendCC.__spliced.buildHost or backendCC;
  arch = lib.replaceStrings [ "." ] [ "" ] (lib.head cudaConfig.cudaCapabilities);
  # Keep nested-release coverage on this tested pair. The floating CUDA 13
  # alias may select a release without compatibility driver archives.
  parentCuda =
    if lib.versions.major cudaMajorMinorVersion == "12" then
      buildPackages.cudaPackages_13_3
    else
      buildPackages.cudaPackages_12_9;
  parentNvcc = parentCuda.cuda_nvcc;
  # Inspect the runtime selected by the invoked producer, including its TARGET
  # role. Looking up CUDART in the BUILD scope can select another CPU's driver.
  parentCudart =
    lib.findFirst (input: (input.pname or null) == "cuda_cudart")
      (throw "${cudaNamePrefix}-tests-nvcc-runtime: parent NVCC has no TARGET CUDART")
      parentNvcc.depsTargetTargetPropagated;
in
stdenvNoCC.mkDerivation {
  name = "${cudaNamePrefix}-tests-nvcc-runtime";
  strictDeps = true;
  # Reference the compiler directly, without activating its setup hook.
  # The packaged backend and CUDA runtime must work without build-time flags.
  buildCommand = ''
    ${import ../../test-support.nix { inherit buildPackages lib; }}
    mkdir -p "$out"
    cat > saxpy.cu <<'CUDA'
    #include <cuda/std/type_traits>
    extern "C" __global__ void saxpy(int n, float a, const float *x, float *y) {
      int i = blockIdx.x * blockDim.x + threadIdx.x;
      if (i < n) y[i] = a * x[i] + y[i];
    }
    extern "C" int runSaxpy(int n, float a, const float *x, float *y) {
      saxpy<<<(n + 255) / 256, 256>>>(n, a, x, y);
      return cudaDeviceSynchronize();
    }
    CUDA

    compileEnv=()
    compile() {
      runStandalone "''${compileEnv[@]}" ${lib.getExe nvcc} "$@"
    }
    # Math alone does not exercise the frontend's ordinary C++ library support.
    cat > stdlib.cu <<'CUDA'
    #include <cmath>
    #include <string>
    #include <iostream>
    #if ${
      if cc.libcxx.isLLVM or false then
        "!defined(_LIBCPP_VERSION) || defined(__GLIBCXX__)"
      else
        "!defined(__GLIBCXX__) || defined(_LIBCPP_VERSION)"
    }
    #error NVCC selected the wrong C++ standard library headers
    #endif
    int main(int argc, char **argv) {
      std::string message = argc == 2 ? argv[1] : "";
      message.append(" stdlib");
      double value = std::sqrt(9.0) + std::pow(2.0, 3.0);
      std::cout << message << " " << value << "\n";
      return message != "NVCC stdlib" || value != 11.0;
    }
    CUDA

    # Host checks run without a GPU. Retain the same executables for installed
    # GPU checks: compilation alone missed silently omitted math operations.
    for standard in 17 20; do
      compile -std=c++$standard -arch=sm_${arch} ${./nvcc-math.cu} \
        -o "$out/math-c++$standard"
      compile -std=c++$standard -arch=sm_${arch} stdlib.cu \
        -o "$out/stdlib-c++$standard"
      ${lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
        "$out/math-c++$standard" --host-only
        [[ $(runStandalone "$out/stdlib-c++$standard" NVCC) == "NVCC stdlib 11" ]]
      ''}
    done

    compile -ptx -arch=compute_${arch} saxpy.cu -o "$out/saxpy.ptx"
    compile -cubin -arch=sm_${arch} saxpy.cu -o "$out/saxpy.cubin"
    compile -shared -arch=sm_${arch} -Xcompiler=-fPIC --cudart=shared \
      saxpy.cu -o "$out/saxpy.so"

    # The default cudart path can conceal missing dependency search paths at
    # device link time. A separate device library must also be found through
    # each of bintools-wrapper's ordered linker flag variables.
    cat > scale.cu <<'CUDA'
    __device__ float scale(float a, float x) { return a * x; }
    CUDA
    mkdir device-lib
    compile -dc -arch=sm_${arch} -Xcompiler=-fPIC scale.cu -o scale.o
    compile -lib scale.o -o device-lib/libscale.a
    sed 's/a \* x\[i\]/scale(a, x[i])/' saxpy.cu > separate.cu
    sed -i '1i__device__ float scale(float a, float x);' separate.cu
    for variable in NIX_LDFLAGS_BEFORE NIX_LDFLAGS NIX_LDFLAGS_AFTER; do
      # A previous invocation's private profile input must be recomputed.
      compileEnv=("$variable="$'\n'"-L $PWD/device-lib" "NIX_NVCC_LIBRARIES=-L$PWD/missing-private-path")
      compile -shared -rdc=true -arch=sm_${arch} -Xcompiler=-fPIC --cudart=shared \
        separate.cu -lscale -o "$out/saxpy-$variable.so"
    done
    # GNU ld accepts both long-option spellings too. The host backend alone
    # finding the archive must not conceal a missing device-link search path.
    libraryPathFlags=("--library-path=$PWD/device-lib" "--library-path $PWD/device-lib")
    for i in "''${!libraryPathFlags[@]}"; do
      compileEnv=("NIX_LDFLAGS=''${libraryPathFlags[i]}")
      compile -shared -rdc=true -arch=sm_${arch} -Xcompiler=-fPIC --cudart=shared \
        separate.cu -lscale -o "$out/saxpy-long-library-path-$i.so"
    done
    compileEnv=()

    explicitLibraryPath() {
      libraryFlags=()
      if [[ $1 == argv ]]; then
        libraryFlags=("-L$2")
      else
        compileEnv+=("$1=-L$2")
      fi
    }

    # An explicit library directory must retain precedence over dependency
    # paths. The shadow archive deliberately lacks the needed device symbol.
    mkdir shadow-device-lib
    echo '__device__ float other(float a, float x) { return a * x; }' > other.cu
    compile -dc -arch=sm_${arch} -Xcompiler=-fPIC other.cu -o other.o
    compile -lib other.o -o shadow-device-lib/libscale.a
    for variable in NIX_LDFLAGS_BEFORE NIX_LDFLAGS NIX_LDFLAGS_AFTER; do
      for channel in argv NVCC_PREPEND_FLAGS NVCC_APPEND_FLAGS; do
        compileEnv=("$variable=-L$PWD/shadow-device-lib")
        explicitLibraryPath "$channel" "$PWD/device-lib"
        compile -shared -rdc=true -arch=sm_${arch} -Xcompiler=-fPIC --cudart=shared \
          separate.cu "''${libraryFlags[@]}" -lscale -o "$out/saxpy-explicit-path-$variable-$channel.so"
      done
    done
    compileEnv=()

    # The adaptation must preserve host-library selection as well. These
    # ordinary C++ objects make a missing symbol fail without GPU execution.
    mkdir host-lib shadow-host-lib
    echo 'extern "C" int selectedLibrary() { return 0; }' > host-library.cpp
    echo 'extern "C" int otherLibrary() { return 0; }' > shadow-host-library.cpp
    echo 'extern "C" int selectedLibrary(); int main() { return selectedLibrary(); }' > host-main.cpp
    compile -c host-library.cpp -o host-library.o
    compile -c shadow-host-library.cpp -o shadow-host-library.o
    compile -lib host-library.o -o host-lib/libchoice.a
    compile -lib shadow-host-library.o -o shadow-host-lib/libchoice.a
    for variable in NIX_LDFLAGS_BEFORE NIX_LDFLAGS NIX_LDFLAGS_AFTER; do
      for channel in argv NVCC_PREPEND_FLAGS NVCC_APPEND_FLAGS; do
        compileEnv=("$variable=-L$PWD/shadow-host-lib")
        explicitLibraryPath "$channel" "$PWD/host-lib"
        compile host-main.cpp "''${libraryFlags[@]}" -lchoice -o "$out/host-explicit-path-$variable-$channel"
      done
    done
    compileEnv=()

    # A standalone host link must locate the real driver before its link-time
    # stub, even though no stdenv fixup hook processes these outputs.
    cat > driver.cpp <<'CPP'
    #include <cuda.h>
    #ifdef DRIVER_MAIN
    int main() { return (int)cuInit(0) == 77 ? 0 : 1; }
    #else
    extern "C" int driverStatus() { return (int)cuInit(0); }
    #endif
    CPP
    compile --cudart=none -shared -Xcompiler=-fPIC driver.cpp -lcuda -o "$out/driver-default.so"
    driverRunpath=$(${cc.bintools}/bin/${cc.targetPrefix}readelf -d "$out/driver-default.so" \
      | sed -n 's/.*(RUNPATH).*\[\(.*\)\].*/\1/p')
    driverStubs='${lib.getOutput cuda_cudart.outputStubs cuda_cudart}/lib/stubs'
    [[ ":$driverRunpath:" == *":$driverStubs:"* ]]
    [[ ":''${driverRunpath%%"$driverStubs"*}" == *':${cuda_cudart.driverRunpath}:'* ]] || {
      echo "Standalone NVCC did not put its runtime driver before the stub: $driverRunpath" >&2
      exit 1
    }

    # Runtime overrides are independent of -L link-time library selection.
    # The fake driver makes these checks runnable without a GPU; retain the
    # cross executables for the matching HOST's installed runtime checks.
    mkdir "$out/driver-override"
    cat > fake-driver.cpp <<'CPP'
    #include <cuda.h>
    extern "C" CUresult CUDAAPI cuInit(unsigned int) { return (CUresult)77; }
    CPP
    compile --cudart=none -shared -Xcompiler=-fPIC fake-driver.cpp \
      -Xlinker=-soname,libcuda.so.1 -o "$out/driver-override/libcuda.so.1"
    for channel in argv NVCC_PREPEND_FLAGS NVCC_APPEND_FLAGS NIX_LDFLAGS_BEFORE NIX_LDFLAGS NIX_LDFLAGS_AFTER; do
      compileEnv=()
      driverFlags=()
      case "$channel" in
        argv) driverFlags=("-Xlinker=-rpath,$out/driver-override") ;;
        NVCC_*) compileEnv=("$channel=-Xlinker=-rpath,$out/driver-override") ;;
        *) compileEnv=("$channel=-rpath $out/driver-override") ;;
      esac
      compile --cudart=none -DDRIVER_MAIN driver.cpp -lcuda \
        "''${driverFlags[@]}" -o "$out/driver-runtime-$channel"
      driverRunpath=$(${cc.bintools}/bin/${cc.targetPrefix}readelf -d "$out/driver-runtime-$channel" \
        | sed -n 's/.*(RUNPATH).*\[\(.*\)\].*/\1/p')
      [[ ":$driverRunpath:" == *':${cuda_cudart.driverRunpath}:'* ]]
      [[ ":''${driverRunpath%%"${cuda_cudart.driverRunpath}"*}" == *":$out/driver-override:"* ]]
      [[ ":''${driverRunpath%%"$driverStubs"*}" == *':${cuda_cudart.driverRunpath}:'* ]]
      ${lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
        env -i "$out/driver-runtime-$channel"
      ''}
    done
    compileEnv=()
  ''
  + lib.optionalString cc.isGNU ''
    # NVCC exports its computed profile to backend subprocesses. A nested
    # compiler must use its own SDK headers and libraries, even across releases.
    cat > launch-profile-nvcc <<'SH'
    #!${buildPackages.runtimeShell}
    set -e
    ${lib.getExe nvcc} -M -arch=compute_${arch} saxpy.cu > nested-profile.d
    grep -F '${lib.getInclude cccl}/include/cuda/std/type_traits' nested-profile.d || {
      echo 'Nested NVCC selected the wrong CCCL headers' >&2
      exit 1
    }
    ${lib.getExe nvcc} -shared -arch=sm_${arch} -Xcompiler=-fPIC --cudart=shared \
      saxpy.cu -o "$NVCC_PROFILE_OUTPUT"
    childDriverRunpath=$(${cc.bintools}/bin/${cc.targetPrefix}readelf -d "$NVCC_PROFILE_OUTPUT" \
      | ${buildPackages.gnused}/bin/sed -n 's/.*(RUNPATH).*\[\(.*\)\].*/\1/p')
    [[ ":$childDriverRunpath:" == *':${cuda_cudart.driverRunpath}:'* ]]
    for parentDriverPath in ${lib.escapeShellArgs (lib.subtractLists (lib.splitString ":" cuda_cudart.driverRunpath) (lib.splitString ":" parentCudart.driverRunpath))}; do
      [[ ":$childDriverRunpath:" != *":$parentDriverPath:"* ]] || {
        echo "Nested NVCC retained its parent's driver projection: $childDriverRunpath" >&2
        exit 1
      }
    done
    exec "$@"
    SH
    chmod +x launch-profile-nvcc
    runStandalone PATH=${
      lib.makeBinPath [
        buildPackages.coreutils
        buildPackages.bash
        buildPackages.gnugrep
      ]
    } \
      "NVCC_PROFILE_OUTPUT=$out/saxpy-inherited-profile.so" \
      ${lib.getExe parentNvcc} -E \
      -Xcompiler=-wrapper,"$PWD/launch-profile-nvcc" saxpy.cu -o /dev/null
    runtimeSoname=$(${cc.bintools}/bin/${cc.targetPrefix}readelf \
      -d ${lib.getLib cuda_cudart}/lib/libcudart.so | sed -n 's/.*(SONAME).*\[\(.*\)\].*/\1/p')
    test -n "$runtimeSoname"
    ${cc.bintools}/bin/${cc.targetPrefix}readelf -d "$out/saxpy-inherited-profile.so" \
      | grep -F "Shared library: [$runtimeSoname]" || {
        echo "Nested NVCC did not link its own $runtimeSoname" >&2
        exit 1
      }
  ''
  +
    lib.optionalString (cc.isGNU && lib.systems.equals stdenvNoCC.buildPlatform stdenvNoCC.hostPlatform)
      ''
        # GCC's -wrapper runs a subprocess after its Nix wrapper has exported
        # initialized compiler/linker flags. A nested NVCC must select its own
        # role again, even when both roles target the same CPU and share salts.
        compiler=$(readlink -f ${lib.getExe nvcc})
        compilerPrefix="''${compiler%/bin/nvcc}"
        compilerSalt="''${compilerPrefix##*/}"
        compilerSalt="''${compilerSalt%%-*}"
        cat > inherited.cu <<'CUDA'
        #ifdef BUILD_ONLY
        #error BUILD flags leaked into HOST NVCC
        #endif
        #ifndef HOST_ONLY
        #error HOST flags are missing from HOST NVCC
        #endif
        CUDA
        cat separate.cu >> inherited.cu
        mkdir empty-build-lib
        echo 'int parent;' > parent.cpp
        cat > launch-nvcc <<'SH'
        #!${buildPackages.runtimeShell}
        set -e
        ${lib.getExe nvcc} -shared -rdc=true -arch=sm_${arch} -Xcompiler=-fPIC --cudart=shared \
          inherited.cu -lscale -o "$NVCC_INHERITED_OUTPUT"
        exec "$@"
        SH
        chmod +x launch-nvcc
        for role in BUILD HOST; do
          runStandalone "NIX_NVCC_TARGET_HOST_$compilerSalt=1" \
            "NIX_CC_WRAPPER_TARGET_''${role}_${cc.suffixSalt}=1" \
            "NIX_BINTOOLS_WRAPPER_TARGET_''${role}_${
              cc.bintools.suffixSalt or cc.bintools.env.suffixSalt
            }=1" \
            NIX_CFLAGS_COMPILE=-DHOST_ONLY NIX_CFLAGS_COMPILE_FOR_BUILD=-DBUILD_ONLY \
            "NIX_LDFLAGS=-L $PWD/device-lib" "NIX_LDFLAGS_FOR_BUILD=-L $PWD/empty-build-lib" \
            "NVCC_INHERITED_OUTPUT=$out/saxpy-inherited-$role.so" \
            ${cc}/bin/${cc.targetPrefix}c++ -wrapper "$PWD/launch-nvcc" -E parent.cpp -o /dev/null
        done

        # An NVCC parent also projects its selected backend into NVCC_CCBIN.
        # The child must recover its HOST input instead of inheriting BUILD's
        # backend as an explicit override, including when HOST uses the default.
        cat > build-backend <<'SH'
        #!${buildPackages.runtimeShell}
        if [[ -n ''${NVCC_NESTED_CHILD-} ]]; then
          echo "BUILD backend leaked into HOST NVCC" >&2
          exit 1
        fi
        exec ${cc}/bin/${cc.targetPrefix}c++ "$@"
        SH
        cat > launch-role-nvcc <<'SH'
        #!${buildPackages.runtimeShell}
        set -e
        env -u "NIX_NVCC_TARGET_BUILD_$NVCC_COMPILER_SALT" \
          "NIX_NVCC_TARGET_HOST_$NVCC_COMPILER_SALT=1" NVCC_NESTED_CHILD=1 \
          ${lib.getExe nvcc} -ptx -arch=compute_${arch} saxpy.cu -o "$out/saxpy-nested.ptx"
        exec "$@"
        SH
        chmod +x build-backend launch-role-nvcc
        compileEnv=(
          "NIX_NVCC_TARGET_BUILD_$compilerSalt=1"
          "NVCC_CCBIN_FOR_BUILD=$PWD/build-backend"
          "NVCC_COMPILER_SALT=$compilerSalt"
          "out=$out"
        )
        compile -ptx -arch=compute_${arch} -Xcompiler=-wrapper,"$PWD/launch-role-nvcc" \
          saxpy.cu -o "$out/saxpy-parent.ptx"
      '';
}
