{
  kit,
  stdenv,
  runCommand,
  pkg-config,
  writeText,
}:
{
  mkl-libs = stdenv.mkDerivation {
    name = "intel-oneapi-test-mkl-libs";
    src = writeText "test.c" ''
      #include <assert.h>
      #include <mkl_cblas.h>
      int main() {
        float u[] = {1., 2., 3.};
        float v[] = {4., 5., 6.};
        float dp = cblas_sdot(3, u, 1, v, 1);
        assert(dp == 32.);
      }
    '';
    dontUnpack = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ kit ];
    buildPhase = ''
      # This will fail if no libs with mkl- in their name are found
      libs="$(pkg-config --list-all | cut -d\  -f1 | grep mkl-)"
      [ -n "$libs" ] || { echo "No MKL libs found via pkg-config" >&2; exit 1; }
      for lib in $libs; do
        echo "Testing that the build succeeds with $lib" >&2
        gcc $src -o test-with-$lib $(pkg-config --cflags --libs $lib)
      done
    '';
    doCheck = true;
    checkPhase = ''
      for lib in $libs; do
        echo "Testing that the executable built with $lib runs" >&2
        ./test-with-$lib
      done
    '';
    installPhase = ''touch "$out"'';
  };

  all-binaries-run = runCommand "intel-oneapi-test-all-binaries-run" { } ''
    # .*-32: 32-bit executables can't be properly patched by patchelf
    # IMB-.*: all fail with a weird "bad file descriptor" error
    # fi_info, fi_pingpong: exits with 1 even if ran with `--help`
    # gdb-oneapi: Python not initialized
    # hydra_bstrap_proxy, hydra_nameserver, hydra_pmi_proxy: doesn't respect --help
    # mpirun: can't find mpiexec.hydra for some reason
    # sycl-ls, sycl-trace: doesn't respect --help
    regex_skip="(.*-32)|(IMB-.*)|fi_info|fi_pingpong|gdb-oneapi|hydra_bstrap_proxy|hydra_nameserver|hydra_pmi_proxy|mpirun|sycl-ls|sycl-trace"
    export I_MPI_ROOT="${kit}/mpi/latest"
    for bin in "${kit}"/bin/*; do
      if [[ "$bin" =~ $regex_skip ]] || [ ! -f "$bin" ] || [[ ! -x "$bin" ]]; then
        echo "skipping $bin"
        continue
      fi
      echo "trying to run $bin --help or -help"
      "$bin" --help || "$bin" -help
    done
    touch "$out"
  '';

  sycl-compile = kit.stdenv.mkDerivation {
    name = "intel-oneapi-test-sycl-compile";
    src = writeText "test.cpp" ''
      #include <sycl/sycl.hpp>
      #include <iostream>
      int main() {
        // We likely won't have a SYCL device available,
        // due to the nix sandbox, but this test only
        // verifies that SYCL compiles, so we don't need a device
        try {
            sycl::queue q;
            std::cout << q.get_device().get_info<sycl::info::device::name>() << std::endl;
        } catch (const sycl::exception& e) {
            std::cerr << "No SYCL device found: " << e.what() << std::endl;
        }
        return 0;
      }
    '';
    dontUnpack = true;
    buildPhase = "icpx -fsycl $src -o test";
    doCheck = true;
    checkPhase = "./test";
    installPhase = ''touch "$out"'';
  };

  headers-available = kit.stdenv.mkDerivation {
    name = "intel-oneapi-test-headers-available";
    dontUnpack = true;
    buildPhase = ''
      echo '#include <sycl/sycl.hpp>' | icpx -fsycl -x c++ -E - > /dev/null
      echo '#include <CL/sycl.hpp>'   | icpx -fsycl -x c++ -E - > /dev/null
      echo '#include <iostream>'      | icpx -x c++ -E - > /dev/null
    '';
    installPhase = ''touch "$out"'';
  };

  c-compile = kit.stdenv.mkDerivation {
    name = "intel-oneapi-test-c-compile";
    src = writeText "test.c" ''
      #include <stdio.h>
      int main() { printf("Hello from Intel C compiler!\n"); return 0; }
    '';
    dontUnpack = true;
    buildPhase = "icx $src -o test";
    doCheck = true;
    checkPhase = "./test";
    installPhase = ''touch "$out"'';
  };

  openmp-compile = kit.stdenv.mkDerivation {
    name = "intel-oneapi-test-openmp-compile";
    src = writeText "test.c" ''
      #include <omp.h>
      #include <stdio.h>
      int main() {
        #pragma omp parallel
        { printf("Hello from thread %d\n", omp_get_thread_num()); }
        return 0;
      }
    '';
    dontUnpack = true;
    buildPhase = "icx -fiopenmp $src -o test";
    doCheck = true;
    checkPhase = "./test";
    installPhase = ''touch "$out"'';
  };
}
