{
  lib,
  stdenv,
  runCommandCC,
  compiler-rt,
  noLibcCompiler,
  src,
  patches,
}:
runCommandCC "${compiler-rt.name}-assertions"
  {
    strictDeps = true;
  }
  ''
    cp -r ${src}/compiler-rt/lib/builtins source
    chmod -R u+w source
    for patchFile in ${lib.escapeShellArgs (map (patch: "${patch}") patches)}; do
      patch --fuzz=0 -d source -p3 < "$patchFile"
    done

    archives=( ${compiler-rt}/lib/linux/libclang_rt.builtins-*.a )
    test "''${#archives[@]}" = 1
    archive="''${archives[0]}"

    # Explicitly link this archive: the driver's default runtime may instead
    # select the separate libc-enabled compiler-rt and hide the regression.
    cat > cpu.c <<'SOURCE'
    int main(void) {
      __builtin_cpu_init();
      volatile int features = __builtin_cpu_supports("sse2");
      return features < 0;
    }
    SOURCE
    $CC cpu.c "$archive" -o cpu

    for mode in debug release; do
      flags=()
      if [[ $mode = release ]]; then flags+=( -DNDEBUG ); fi
      for input in cpu_model/x86.c clear_cache.c; do
        ${noLibcCompiler}/bin/${noLibcCompiler.targetPrefix}cc \
          -std=c11 -nodefaultlibs -Werror=implicit-function-declaration \
          "''${flags[@]}" -c "source/$input" -o "$(basename "$input").o"
      done
    done

    cat > semantics.c <<'SOURCE'
    #ifdef __cplusplus
    extern "C" {
    #endif
    #include "int_lib.h"
    #ifdef __cplusplus
    }
    #endif
    COMPILE_TIME_ASSERT(sizeof(int) >= 2);
    int main(void) {
      int count = 0;
      COMPILER_RT_ASSERT(++count == 1);
    #ifdef NDEBUG
      return count != 0;
    #else
      return count != 1;
    #endif
    }
    SOURCE
    echo '#include "int_lib.h"' > false.c
    echo 'COMPILE_TIME_ASSERT(0);' >> false.c
    for language in c c++; do
      for mode in debug release; do
        flags=()
        if [[ $mode = release ]]; then flags+=( -DNDEBUG ); fi
        $CXX -x "$language" -Isource "''${flags[@]}" semantics.c \
          -x none "$archive" -o "$language-$mode"
      done
      if $CXX -x "$language" -Isource -c false.c -o false.o; then
        echo "false compile-time assertion was accepted" >&2
        exit 1
      fi
    done

    cat > runtime-false.c <<'SOURCE'
    #include "int_lib.h"
    int main(void) { COMPILER_RT_ASSERT(0); return 0; }
    SOURCE
    $CC -Isource runtime-false.c "$archive" -o runtime-false

    ${lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      ./cpu
      ulimit -c 0
      if ./runtime-false; then
        echo "false runtime assertion was accepted" >&2
        exit 1
      fi
      for consumer in c-debug c-release c++-debug c++-release; do
        ./"$consumer"
      done
    ''}
    mkdir "$out"
    cp cpu c-debug c-release c++-debug c++-release "$out/"
  ''
