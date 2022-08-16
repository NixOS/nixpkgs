{ lib, stdenv, fetchFromGitHub, perl, yasm
, vp8DecoderSupport ? true # VP8 decoder
, vp8EncoderSupport ? true # VP8 encoder
, vp9DecoderSupport ? true # VP9 decoder
, vp9EncoderSupport ? true # VP9 encoder
, extraWarningsSupport ? false # emit non-fatal warnings
, werrorSupport ? false # treat warnings as errors (not available with all compilers)
, debugSupport ? false # debug mode
, gprofSupport ? false # gprof profiling instrumentation
, gcovSupport ? false # gcov coverage instrumentation
, sizeLimitSupport ? true # limit max size to allow in the decoder
, optimizationsSupport ? true # compiler optimization flags
, runtimeCpuDetectSupport ? true # detect cpu capabilities at runtime
, thumbSupport ? false # build arm assembly in thumb mode
, examplesSupport ? true # build examples (vpxdec & vpxenc are part of examples)
, debugLibsSupport ? false # include debug version of each library
, postprocSupport ? true # postprocessing
, multithreadSupport ? true # multithreaded decoding & encoding
, internalStatsSupport ? false # output of encoder internal stats for debug, if supported (encoders)
, spatialResamplingSupport ? true # spatial sampling (scaling)
, realtimeOnlySupport ? false # build for real-time encoding
, ontheflyBitpackingSupport ? false # on-the-fly bitpacking in real-time encoding
, errorConcealmentSupport ? false # decoder conceals losses
, smallSupport ? false # favor smaller binary over speed
, postprocVisualizerSupport ? false # macro block/block level visualizers
, unitTestsSupport ? false, curl ? null, coreutils ? null # unit tests
, webmIOSupport ? true # input from and output to webm container
, libyuvSupport ? true # libyuv
, decodePerfTestsSupport ? false # build decoder perf tests with unit tests
, encodePerfTestsSupport ? false # build encoder perf tests with unit tests
, multiResEncodingSupport ? false # multiple-resolution encoding
, temporalDenoisingSupport ? true # use temporal denoising instead of spatial denoising
, coefficientRangeCheckingSupport ? false # decoder checks if intermediate transform coefficients are in valid range
, vp9HighbitdepthSupport ? true # 10/12 bit color support in VP9
# Experimental features
, experimentalSpatialSvcSupport ? false # Spatial scalable video coding
, experimentalFpMbStatsSupport ? false
, experimentalEmulateHardwareSupport ? false
}:

let
  inherit (stdenv) is64bit isMips isDarwin isCygwin;
  inherit (lib) enableFeature optional optionals;
in

assert vp8DecoderSupport || vp8EncoderSupport || vp9DecoderSupport || vp9EncoderSupport;
assert internalStatsSupport && (vp9DecoderSupport || vp9EncoderSupport) -> postprocSupport;
/* If spatialResamplingSupport not enabled, build will fail with undeclared variable errors.
   Variables called in vpx_scale/generic/vpx_scale.c are declared by vpx_scale/vpx_scale_rtcd.pl,
   but is only executed if spatialResamplingSupport is enabled */
assert spatialResamplingSupport;
assert postprocVisualizerSupport -> postprocSupport;
assert unitTestsSupport -> curl != null && coreutils != null;
assert vp9HighbitdepthSupport -> (vp9DecoderSupport || vp9EncoderSupport);
assert isCygwin -> unitTestsSupport && webmIOSupport && libyuvSupport;

stdenv.mkDerivation rec {
  pname = "libvpx";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "webmproject";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9SFFE2GfYYMgxp1dpmL3STTU2ea1R5vFKA1L0pZwIvQ=";
  };

  postPatch = ''
    patchShebangs --build \
      build/make/*.sh \
      build/make/*.pl \
      build/make/*.pm \
      test/*.sh \
      configure

    # When cross-compiling (for aarch64-multiplatform), the compiler errors out on these flags.
    # Since they're 'just' warnings, it's fine to just remove them.
    substituteInPlace configure \
      --replace "check_add_cflags -Wparentheses-equality" "" \
      --replace "check_add_cflags -Wunreachable-code-loop-increment" "" \
      --replace "check_cflags -Wshorten-64-to-32 && add_cflags_only -Wshorten-64-to-32" ""
  '';

  outputs = [ "bin" "dev" "out" ];
  setOutputFlags = false;

  configurePlatforms = [];
  configureFlags = [
    (enableFeature (vp8EncoderSupport || vp8DecoderSupport) "vp8")
    (enableFeature vp8EncoderSupport "vp8-encoder")
    (enableFeature vp8DecoderSupport "vp8-decoder")
    (enableFeature (vp9EncoderSupport || vp9DecoderSupport) "vp9")
    (enableFeature vp9EncoderSupport "vp9-encoder")
    (enableFeature vp9DecoderSupport "vp9-decoder")
    (enableFeature extraWarningsSupport "extra-warnings")
    (enableFeature werrorSupport "werror")
    "--disable-install-docs"
    (enableFeature examplesSupport "install-bins")
    "--enable-install-libs"
    "--disable-install-srcs"
    (enableFeature debugSupport "debug")
    (enableFeature gprofSupport "gprof")
    (enableFeature gcovSupport "gcov")
    # Required to build shared libraries
    (enableFeature (!isCygwin) "pic")
    (enableFeature optimizationsSupport "optimizations")
    (enableFeature runtimeCpuDetectSupport "runtime-cpu-detect")
    (enableFeature thumbSupport "thumb")
    "--enable-libs"
    (enableFeature examplesSupport "examples")
    "--disable-docs"
    "--as=yasm"
    # Limit default decoder max to WHXGA
    (if sizeLimitSupport then "--size-limit=5120x3200" else null)
    "--disable-codec-srcs"
    (enableFeature debugLibsSupport "debug-libs")
    (enableFeature isMips "dequant-tokens")
    (enableFeature isMips "dc-recon")
    (enableFeature postprocSupport "postproc")
    (enableFeature (postprocSupport && (vp9DecoderSupport || vp9EncoderSupport)) "vp9-postproc")
    (enableFeature multithreadSupport "multithread")
    (enableFeature internalStatsSupport "internal-stats")
    (enableFeature spatialResamplingSupport "spatial-resampling")
    (enableFeature realtimeOnlySupport "realtime-only")
    (enableFeature ontheflyBitpackingSupport "onthefly-bitpacking")
    (enableFeature errorConcealmentSupport "error-concealment")
    # Shared libraries are only supported on ELF platforms
    (if isDarwin || isCygwin then
       "--enable-static --disable-shared"
     else
       "--enable-shared")
    (enableFeature smallSupport "small")
    (enableFeature postprocVisualizerSupport "postproc-visualizer")
    (enableFeature unitTestsSupport "unit-tests")
    (enableFeature webmIOSupport "webm-io")
    (enableFeature libyuvSupport "libyuv")
    (enableFeature decodePerfTestsSupport "decode-perf-tests")
    (enableFeature encodePerfTestsSupport "encode-perf-tests")
    (enableFeature multiResEncodingSupport "multi-res-encoding")
    (enableFeature temporalDenoisingSupport "temporal-denoising")
    (enableFeature (temporalDenoisingSupport && (vp9DecoderSupport || vp9EncoderSupport)) "vp9-temporal-denoising")
    (enableFeature coefficientRangeCheckingSupport "coefficient-range-checking")
    (enableFeature (vp9HighbitdepthSupport && is64bit) "vp9-highbitdepth")
    (enableFeature (experimentalSpatialSvcSupport ||
                    experimentalFpMbStatsSupport ||
                    experimentalEmulateHardwareSupport) "experimental")
  ] ++ optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # libvpx darwin targets include darwin version (ie. ARCH-darwinXX-gcc, XX being the darwin version)
    # See all_platforms: https://github.com/webmproject/libvpx/blob/master/configure
    # Darwin versions: 10.4=8, 10.5=9, 10.6=10, 10.7=11, 10.8=12, 10.9=13, 10.10=14
    "--force-target=${stdenv.hostPlatform.parsed.cpu.name}-${stdenv.hostPlatform.parsed.kernel.name}${
            if stdenv.hostPlatform.isDarwin then
              if      stdenv.hostPlatform.osxMinVersion == "10.10" then "14"
              else if stdenv.hostPlatform.osxMinVersion == "10.9"  then "13"
              else if stdenv.hostPlatform.osxMinVersion == "10.8"  then "12"
              else if stdenv.hostPlatform.osxMinVersion == "10.7"  then "11"
              else if stdenv.hostPlatform.osxMinVersion == "10.6"  then "10"
              else if stdenv.hostPlatform.osxMinVersion == "10.5"  then "9"
              else "8"
            else ""}-gcc"
    (if stdenv.hostPlatform.isCygwin then "--enable-static-msvcrt" else "")
  ] # Experimental features
    ++ optional experimentalSpatialSvcSupport "--enable-spatial-svc"
    ++ optional experimentalFpMbStatsSupport "--enable-fp-mb-stats"
    ++ optional experimentalEmulateHardwareSupport "--enable-emulate-hardware";

  nativeBuildInputs = [ perl yasm ];

  buildInputs = [ ]
    ++ optionals unitTestsSupport [ coreutils curl ];

  NIX_LDFLAGS = [
    "-lpthread" # fixes linker errors
  ];

  enableParallelBuilding = true;

  postInstall = ''moveToOutput bin "$bin" '';

  meta = with lib; {
    description = "WebM VP8/VP9 codec SDK";
    homepage    = "https://www.webmproject.org/";
    changelog   = "https://github.com/webmproject/libvpx/raw/v${version}/CHANGELOG";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ codyopel ];
    platforms   = platforms.all;
  };
}
