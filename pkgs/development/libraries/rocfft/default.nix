{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, runCommand
, cmake
, rocm-cmake
, rocrand
, hip
, openmp
, sqlite
, python3
, gtest
, boost
, fftw
, fftwFloat
, buildTests ? false
, buildBenchmarks ? false
}:

let
  # This is over 3GB, to allow hydra caching we separate it
  rf = stdenv.mkDerivation (finalAttrs: {
    pname = "rocfft";
    version = "5.4.3";

    outputs = [
      "out"
    ] ++ lib.optionals buildTests [
      "test"
    ] ++ lib.optionals buildBenchmarks [
      "benchmark"
    ];

    src = fetchFromGitHub {
      owner = "ROCmSoftwarePlatform";
      repo = "rocFFT";
      rev = "rocm-${finalAttrs.version}";
      hash = "sha256-FsefE0B2hF5ZcHDB6TscwFeZ1NKFkWX7VDpEvvbDbOk=";
    };

    nativeBuildInputs = [
      cmake
      rocm-cmake
      hip
    ];

    buildInputs = [
      sqlite
      python3
    ] ++ lib.optionals buildTests [
      gtest
    ] ++ lib.optionals (buildTests || buildBenchmarks) [
      rocrand
      boost
      fftw
      fftwFloat
      openmp
    ];

    propogatedBuildInputs = lib.optionals buildTests [
      fftw
      fftwFloat
    ];

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
    ] ++ lib.optionals buildTests [
      "-DBUILD_CLIENTS_TESTS=ON"
    ] ++ lib.optionals buildBenchmarks [
      "-DBUILD_CLIENTS_RIDER=ON"
      "-DBUILD_CLIENTS_SAMPLES=ON"
    ];

    postInstall = lib.optionalString buildTests ''
      mkdir -p $test/{bin,lib/fftw}
      cp -a $out/bin/* $test/bin
      ln -s ${fftw}/lib/libfftw*.so $test/lib/fftw
      ln -s ${fftwFloat}/lib/libfftw*.so $test/lib/fftw
      rm -r $out/lib/fftw
      rm $test/bin/{rocfft_rtc_helper,*-rider} || true
    '' + lib.optionalString buildBenchmarks ''
      mkdir -p $benchmark/bin
      cp -a $out/bin/* $benchmark/bin
      rm $benchmark/bin/{rocfft_rtc_helper,*-test} || true
    '' + lib.optionalString (buildTests || buildBenchmarks ) ''
      mv $out/bin/rocfft_rtc_helper $out
      rm -r $out/bin/*
      mv $out/rocfft_rtc_helper $out/bin
    '';

    passthru.updateScript = rocmUpdateScript {
      name = finalAttrs.pname;
      owner = finalAttrs.src.owner;
      repo = finalAttrs.src.repo;
    };

    meta = with lib; {
      description = "FFT implementation for ROCm ";
      homepage = "https://github.com/ROCmSoftwarePlatform/rocFFT";
      license = with licenses; [ mit ];
      maintainers = teams.rocm.members;
      platforms = platforms.linux;
      broken = versions.minor finalAttrs.version != versions.minor hip.version;
    };
  });

  rf-zero = runCommand "librocfft-device-0.so.0.1" { preferLocalBuild = true; } ''
    cp -a ${rf}/lib/$name $out
  '';

  rf-one = runCommand "librocfft-device-1.so.0.1" { preferLocalBuild = true; } ''
    cp -a ${rf}/lib/$name $out
  '';

  rf-two = runCommand "librocfft-device-2.so.0.1" { preferLocalBuild = true; } ''
    cp -a ${rf}/lib/$name $out
  '';

  rf-three = runCommand "librocfft-device-3.so.0.1" { preferLocalBuild = true; } ''
    cp -a ${rf}/lib/$name $out
  '';
in stdenv.mkDerivation {
  inherit (rf) pname version outputs src passthru meta;

  dontUnpack = true;
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -as ${rf-zero} $out/lib/${rf-zero.name}
    cp -as ${rf-one} $out/lib/${rf-one.name}
    cp -as ${rf-two} $out/lib/${rf-two.name}
    cp -as ${rf-three} $out/lib/${rf-three.name}
    cp -an ${rf}/* $out
  '' + lib.optionalString buildTests ''
    cp -a ${rf.test} $test
  '' + lib.optionalString buildBenchmarks ''
    cp -a ${rf.benchmark} $benchmark
  '' + ''
    runHook postInstall
  '';

  # Fix paths
  preFixup = ''
    substituteInPlace $out/include/*.h $out/rocfft/include/*.h \
      --replace "${rf}" "$out"

    patchelf --set-rpath \
      $(patchelf --print-rpath $out/lib/librocfft.so | sed 's,${rf}/lib,'"$out/lib"',') \
      $out/lib/librocfft.so
  '' + lib.optionalString buildTests ''
    patchelf --set-rpath \
      $(patchelf --print-rpath $test/bin/rocfft-test | sed 's,${rf}/lib,'"$out/lib"',') \
      $test/bin/rocfft-test
  '' + lib.optionalString buildBenchmarks ''
    patchelf --set-rpath \
      $(patchelf --print-rpath $benchmark/bin/rocfft-rider | sed 's,${rf}/lib,'"$out/lib"',') \
      $benchmark/bin/rocfft-rider
  '';
}
