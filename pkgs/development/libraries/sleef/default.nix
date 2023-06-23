{
  config,
  fetchFromGitHub,
  fetchpatch,
  lib,
  stdenv,
  # nativeBuildInputs
  cmake,
  cudaPackages ? {},
  ninja,
  # checkInputs
  fftw,
  gmp,
  mpfr,
  openssl,
  # Configuration options
  buildSharedLibs ? true,
  enableCuda ? config.cudaSupport or false,
}: let
  inherit
    (lib)
    lists
    strings
    ;
  inherit
    (cudaPackages)
    autoAddOpenGLRunpathHook
    backendStdenv
    cuda_cudart
    cuda_nvcc
    cudaFlags
    ;
  cudaArchitectures = builtins.map cudaFlags.dropDot cudaFlags.cudaCapabilities;
  cudaArchitecturesString = strings.concatStringsSep ";" cudaArchitectures;
  setBool = bool:
    if bool
    then "ON"
    else "OFF";
in
  stdenv.mkDerivation (finalAttrs: {
    strictDeps = true;
    pname = "sleef";
    # NOTE: Sleef has fallen into disrepair (https://github.com/shibatch/sleef/issues/442) so we
    # use a newer commit and several patches.
    version = "3.6.0";
    src = fetchFromGitHub {
      owner = "shibatch";
      repo = finalAttrs.pname;
      rev = "85440a5e87dae36ca1b891de14bc83b441ae7c43";
      hash = "sha256-1MPicW6JI5TrsmwtMuxOcdMj3YyGksmUmuBefuA2rJI=";
    };
    patches = [
      (fetchpatch {
        # special case macro redefinition should restore original definition #414
        # - restore macro definitions
        url = "https://github.com/shibatch/sleef/pull/414/commits/0944a608a9ba9735cbc836288e1286032aa2807f.patch";
        hash = "sha256-uEHFlB0zZ55KT6fyrLrDdc1L6LgJ3KkKKO3p9ZZ6jAs=";
      })
      (fetchpatch {
        # Fix gcc warnings #426
        url = "https://github.com/shibatch/sleef/pull/426.patch";
        hash = "sha256-K17H/I8VuLTS/ra6GF3MrlyPsyWJAslj4YZw7RLDhdU=";
      })
      (fetchpatch {
        # Rename global variable to avoid duplicate definitions #454
        url = "https://github.com/shibatch/sleef/pull/454.patch";
        hash = "sha256-3nUtYDYzxP3hnp7OezpMpqz1ZPIP8JdyK5Uv3OzTOx4=";
      })
      (fetchpatch {
        # Support MPFR 4.2.0 (#1)
        url = "https://github.com/sifive/sifive-sleef/pull/1/commits/061e3db7a0c63909d9d2fa2af049621cb98cdf99.patch";
        hash = "sha256-RljNWV/pEPRrSOauFL0iWGiNr+dnFciGIIdxwvdlnYw=";
      })
      (fetchpatch {
        # always inline rempif (returns <2 x REAL>)
        url = "https://github.com/shibatch/sleef/commit/963df4e540c51473fdd95e08f55d1adf208a2f9c.patch";
        hash = "sha256-lpTIdZViaBKV504BzwdQIDwgfe8RxdmswSJlI6JvY5k=";
      })
    ];
    postPatch =
      # GLibc defines M_PIf, so we need to guard against redefinition.
      ''
        for file in src/{common/misc.h,libm-tester/testerutil.h}; do
          substituteInPlace "$file" \
            --replace \
              '#define M_PIf ((float)M_PI)' \
              "$(printf "#ifndef M_PIf\n#define M_PIf ((float)M_PI)\n#endif")"
        done
      ''
      # Uses deprecated OpenSSL functions
      + ''
        substituteInPlace Configure.cmake \
          --replace \
            'set(FLAGS_WALL "' \
            'set(FLAGS_WALL "-Wno-deprecated-declarations '
      ''
      # The tests are broken with GCC 12.0, so we disable them.
      # In particular, the "tanf denormal/nonnumber test" fails.
      + strings.optionalString (!enableCuda) ''
        substituteInPlace src/libm-tester/tester.c \
          --replace \
            "$(printf '{\n      fprintf(stderr, "tanf denormal/nonnumber test : ");')" \
            "$(printf '/* {\n      fprintf(stderr, "tanf denormal/nonnumber test : ");')" \
          --replace \
            "$(printf 'cmpDenorm_f(mpfr_tan, child_tanf, xa[i]);\n      showResult(success);\n    }')" \
            "$(printf 'cmpDenorm_f(mpfr_tan, child_tanf, xa[i]);\n      showResult(success);\n    } */')"
      ''
      # These tests are broken on CUDA (they use the atan function, )
      + strings.optionalString enableCuda ''
        substituteInPlace src/libm-tester/CMakeLists.txt \
          --replace \
            'add_test_iut(iutcuda ' \
            '# add_test_iut(iutcuda '
        substituteInPlace src/quad-tester/CMakeLists.txt \
          --replace \
            'add_test_iut(qiutcuda ' \
            '# add_test_iut(qiutcuda '
      ''
      # tester3 uses implicit function declarations
      + strings.optionalString finalAttrs.doCheck ''
        substituteInPlace Configure.cmake \
          --replace \
            'set(FLAGS_WALL "' \
            'set(FLAGS_WALL "-Wno-implicit-function-declaration '
      '';
    nativeBuildInputs =
      [
        cmake
        ninja
      ]
      ++ lists.optionals enableCuda [
        autoAddOpenGLRunpathHook
        cuda_nvcc
      ];
    buildInputs = lists.optionals enableCuda [cuda_cudart];
    checkInputs = [
      fftw
      gmp
      mpfr
      openssl
    ];
    cmakeFlags =
      [
        "-DBUILD_DFT:BOOL=ON"
        "-DBUILD_INLINE_HEADERS:BOOL=ON"
        "-DBUILD_QUAD:BOOL=ON"
        "-DBUILD_SCALAR_LIB:BOOL=ON"
        "-DBUILD_SHARED_LIBS:BOOL=${setBool buildSharedLibs}"
        "-DBUILD_TESTS:BOOL=${setBool finalAttrs.doCheck}"
        "-DENABLE_CUDA:BOOL=${setBool enableCuda}"
        "-DENABLE_CXX:BOOL=ON"
        "-DENABLE_LTO:BOOL=OFF" # Exclusive with shared libs and doesn't seem handled well by GCC
      ]
      ++ lists.optionals enableCuda [
        "-DCMAKE_C_COMPILER:FILEPATH=${backendStdenv.cc}/bin/cc"
        "-DCMAKE_CUDA_ARCHITECTURES:STRING=${cudaArchitecturesString}"
        "-DCMAKE_CXX_COMPILER:FILEPATH=${backendStdenv.cc}/bin/c++"
      ];
    # Takes a while to do the checks, so disabled by default.
    doCheck = false;
    meta = with lib; {
      description = "SIMD Library for Evaluating Elementary Functions, vectorized libm and DFT";
      homepage = "https://github.com/shibatch/sleef";
      license = licenses.boost;
      maintainers = with maintainers; [connorbaker];
      platforms = platforms.all;
    };
  })
