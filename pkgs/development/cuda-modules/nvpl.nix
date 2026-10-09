{
  buildRedist,
  lib,
  testers,
  nvpl_blas,
  nvpl_lapack,
}:
let
  # NVPL's CMake modules share a relative search prefix which must follow the
  # selected include/library outputs after splitting the binary archive.
  buildNvpl = lib.extendMkDerivation {
    constructDrv = buildRedist;
    excludeDrvArgNames = [ "cmakeSearchPrefix" ];
    extendDrvArgs =
      finalAttrs:
      {
        pname,
        cmakeSearchPrefix ? "_${pname}_search_prefix",
        outputs ? [
          "out"
          "dev"
          "include"
          "lib"
        ],
        postPatch ? "",
        passthru ? { },
        meta ? { },
        ...
      }:
      {
        redistName = "nvpl";
        inherit outputs;
        meta = {
          homepage = "https://developer.nvidia.com/nvpl";
          changelog = "https://docs.nvidia.com/nvpl/latest/${lib.removePrefix "nvpl_" pname}/release_notes.html";
        }
        // meta;
        postPatch = ''
          substituteInPlace lib/cmake/${pname}/${pname}-config.cmake \
            --replace-fail \
              'get_filename_component(${cmakeSearchPrefix} "''${CMAKE_CURRENT_LIST_DIR}/../../" ABSOLUTE)' \
              "set(${cmakeSearchPrefix} \"''${!outputInclude:?}/include;''${!outputLib:?}/lib\")"
        ''
        + postPatch;
        passthru = passthru // {
          tests = {
            cmake = testers.hasCmakeConfigModules {
              package = finalAttrs.finalPackage;
              moduleNames = [ pname ];
            };
          }
          // passthru.tests or { };
        };
      };
  };
in
{
  nvpl_blas = buildNvpl (finalAttrs: {
    pname = "nvpl_blas";

    passthru.tests.cmake-mapped-outputs = testers.hasCmakeConfigModules {
      package = finalAttrs.finalPackage.overrideAttrs {
        outputs = [
          "out"
          "dev"
          "bin"
        ];
        outputInclude = "bin";
        outputLib = "out";
      };
      moduleNames = [ "nvpl_blas" ];
    };

    meta.description = "Part of NVIDIA Performance Libraries that provides standard Fortran 77 BLAS APIs as well as C (CBLAS)";
  });
  nvpl_fft = buildNvpl {
    pname = "nvpl_fft";

    meta.description = "Perform Fast Fourier Transform (FFT) calculations on ARM CPUs";
  };
  nvpl_lapack = buildNvpl {
    pname = "nvpl_lapack";

    propagatedBuildInputs = [ nvpl_blas ];

    meta.description = "Part of NVIDIA Performance Libraries that provides standard Fortran 90 LAPACK and LAPACKE APIs";
  };
  nvpl_rand = buildNvpl {
    pname = "nvpl_rand";
    cmakeSearchPrefix = "nvpl_rand_search_prefix";

    meta.description = "Collection of efficient pseudorandom and quasirandom number generators for ARM CPUs";
  };
  nvpl_scalapack = buildNvpl {
    pname = "nvpl_scalapack";

    propagatedBuildInputs = [
      nvpl_blas
      nvpl_lapack
    ];

    meta.description = "Provides an optimized implementation of ScaLAPACK for distributed-memory architectures";
  };
  nvpl_sparse = buildNvpl {
    pname = "nvpl_sparse";

    meta.description = "Provides a set of CPU-accelerated basic linear algebra subroutines used for handling sparse matrices";
  };
  nvpl_tensor = buildNvpl {
    pname = "nvpl_tensor";

    propagatedBuildInputs = [ nvpl_blas ];

    meta.description = "Part of NVIDIA Performance Libraries that provides tensor primitives";
  };
}
