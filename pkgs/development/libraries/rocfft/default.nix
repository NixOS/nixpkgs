{ rocfft
, lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, hip
, python3
, rocm-cmake
, sqlite
, boost
, fftw
, fftwFloat
, gtest
, openmp
, rocrand
# NOTE: Update the default GPU targets on every update
, gpuTargets ? [
  "gfx803"
  "gfx900"
  "gfx906"
  "gfx908"
  "gfx90a"
  "gfx1030"
  "gfx1100"
  "gfx1102"
]
}:

let
  # To avoid output limit exceeded errors in hydra, we build kernel
  # device libs and the kernel RTC cache database in separate derivations
  kernelDeviceLibs = map
    (target:
      (rocfft.overrideAttrs (prevAttrs: {
        pname = "rocfft-device-${target}";

        patches = prevAttrs.patches ++ [
          # Add back install rule for device library
          # This workaround is needed because rocm_install_targets
          # doesn't support an EXCLUDE_FROM_ALL option
          ./device-install.patch
        ];

        buildFlags = [ "rocfft-device-${target}" ];

        installPhase = ''
          runHook preInstall
          cmake --install . --component device
          runHook postInstall
        '';

        requiredSystemFeatures = [ "big-parallel" ];
      })).override {
        gpuTargets = [ target ];
      }
    )
    gpuTargets;

  # TODO: Figure out how to also split this by GPU target
  #
  # It'll be bit more complicated than what we're doing for the kernel
  # device libs, because the kernel cache needs to be compiled into
  # one sqlite database (whereas the device libs can be linked into
  # rocfft as separate libraries for each GPU target).
  #
  # It's not clear why this needs to even be a db in the first place.
  # It would simplify things A LOT if we could just store these
  # pre-compiled kernels as files (but that'd need a lot of patching).
  kernelRtcCache = rocfft.overrideAttrs (_: {
    pname = "rocfft-kernel-cache";

    buildFlags = [ "rocfft_kernel_cache_target" ];

    installPhase = ''
      runHook preInstall
      cmake --install . --component kernel_cache
      runHook postInstall
    '';

    requiredSystemFeatures = [ "big-parallel" ];
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rocfft";
  version = "5.4.3";

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "rocFFT";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-FsefE0B2hF5ZcHDB6TscwFeZ1NKFkWX7VDpEvvbDbOk=";
  };

  patches = [
    # Exclude kernel compilation & installation from "all" target,
    # and split device libraries by GPU target
    ./split-kernel-compilation.patch
  ];

  nativeBuildInputs = [
    cmake
    hip
    python3
    rocm-cmake
  ];

  buildInputs = [
    sqlite
  ] ++ lib.optionals (finalAttrs.pname == "rocfft") kernelDeviceLibs;

  cmakeFlags = [
    "-DCMAKE_C_COMPILER=hipcc"
    "-DCMAKE_CXX_COMPILER=hipcc"
    "-DUSE_HIP_CLANG=ON"
    "-DSQLITE_USE_SYSTEM_PACKAGE=ON"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DAMDGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
  ];

  postInstall = lib.optionalString (finalAttrs.pname == "rocfft") ''
    ln -s ${kernelRtcCache}/lib/rocfft_kernel_cache.db "$out/lib"
  '';

  passthru = {
    test = stdenv.mkDerivation {
      pname = "${finalAttrs.pname}-test";
      inherit (finalAttrs) version src;

      sourceRoot = "source/clients/tests";

      nativeBuildInputs = [
        cmake
        hip
        rocm-cmake
      ];

      buildInputs = [
        boost
        fftw
        fftwFloat
        finalAttrs.finalPackage
        gtest
        openmp
        rocrand
      ];

      cmakeFlags = [
        "-DCMAKE_C_COMPILER=hipcc"
        "-DCMAKE_CXX_COMPILER=hipcc"
      ];

      postInstall = ''
        rm -r "$out/lib/fftw"
        rmdir "$out/lib"
      '';
    };

    benchmark = stdenv.mkDerivation {
      pname = "${finalAttrs.pname}-benchmark";
      inherit (finalAttrs) version src;

      sourceRoot = "source/clients/rider";

      nativeBuildInputs = [
        cmake
        hip
        rocm-cmake
      ];

      buildInputs = [
        boost
        finalAttrs.finalPackage
        openmp
        (python3.withPackages (ps: with ps; [
          pandas
          scipy
        ]))
        rocrand
      ];

      cmakeFlags = [
        "-DCMAKE_C_COMPILER=hipcc"
        "-DCMAKE_CXX_COMPILER=hipcc"
      ];

      postInstall = ''
        cp -a ../../../scripts/perf "$out/bin"
      '';
    };

    samples = stdenv.mkDerivation {
      pname = "${finalAttrs.pname}-samples";
      inherit (finalAttrs) version src;

      sourceRoot = "source/clients/samples";

      nativeBuildInputs = [
        cmake
        hip
        rocm-cmake
      ];

      buildInputs = [
        boost
        finalAttrs.finalPackage
        openmp
        rocrand
      ];

      cmakeFlags = [
        "-DCMAKE_C_COMPILER=hipcc"
        "-DCMAKE_CXX_COMPILER=hipcc"
      ];

      installPhase = ''
        runHook preInstall
        mkdir "$out"
        cp -a bin "$out"
        runHook postInstall
      '';
    };

    updateScript = rocmUpdateScript {
      name = finalAttrs.pname;
      owner = finalAttrs.src.owner;
      repo = finalAttrs.src.repo;
    };
  };

  meta = with lib; {
    description = "FFT implementation for ROCm";
    homepage = "https://github.com/ROCmSoftwarePlatform/rocFFT";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ kira-bruneau ] ++ teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor hip.version;
  };
})
