{stdenv, fetchgit, perl, yasm
, vp8Support ? true # VP8
, vp8DecoderSupport ? true # VP8 decoder
, vp8EncoderSupport ? true # VP8 encoder
, vp9Support ? true # VP9
, vp9DecoderSupport ? true # VP9 decoder
, vp9EncoderSupport ? true # VP9 encoder
, extraWarningsSupport ? false # emit non-fatal warnings
, werrorSupport ? false # treat warnings as errors (not available with all compilers)
, installBinsSupport ? true # install binaries (vpxdec & vpxenc)
, installLibsSupport ? true # install libraries
, installSrcsSupport ? false # install sources
, debugSupport ? false # debug mode
, gprofSupport ? false # gprof profiling instrumentation
, gcovSupport ? false # gcov coverage instrumentation
, sizeLimitSupport ? true # limit max size to allow in the decoder
, optimizationsSupport ? true # compiler optimization flags
, runtimeCpuDetectSupport ? true # detect cpu capabilities at runtime
, thumbSupport ? false # build arm assembly in thumb mode
, libsSupport ? true # build librares
, examplesSupport ? true # build examples (vpxdec & vpxenc are part of examples)
, fastUnalignedSupport ? true # use unaligned accesses if supported by hardware
, codecSrcsSupport ? false # codec library source code
, debugLibsSupport ? false # include debug version of each library
, postprocSupport ? true # postprocessing
, vp9PostprocSupport ? true # VP9 specific postprocessing
, multithreadSupport ? true # multithreaded decoding & encoding
, internalStatsSupport ? false # output of encoder internal stats for debug, if supported (encoders)
, memTrackerSupport ? false # track memory usage
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
, vp9TemporalDenoisingSupport ? true # VP9 specific temporal denoising
, coefficientRangeCheckingSupport ? false # decoder checks if intermediate transform coefficients are in valid range
, vp9HighbitdepthSupport ? true # 10/12 bit color support in VP9
, experimentalSupport ? false # experimental features
# Experimental features
, experimentalSpatialSvcSupport ? false # Spatial scalable video coding
, experimentalFpMbStatsSupport ? false
, experimentalEmulateHardwareSupport ? false
}:

assert (vp8Support || vp9Support);
assert (vp8DecoderSupport || vp8EncoderSupport || vp9DecoderSupport || vp9EncoderSupport);
assert vp8DecoderSupport -> vp8Support;
assert vp8EncoderSupport -> vp8Support;
assert vp9DecoderSupport -> vp9Support;
assert vp9EncoderSupport -> vp9Support;
assert installLibsSupport -> libsSupport;
# libvpx will not build binaries if examplesSupport is not enabled (ie. vpxdec & vpxenc)
assert installBinsSupport -> examplesSupport;
assert vp9PostprocSupport -> (vp9Support && postprocSupport);
assert (internalStatsSupport && vp9Support) -> vp9PostprocSupport;
/* If spatialResamplingSupport not enabled, build will fail with undeclared variable errors.
   Variables called in vpx_scale/generic/vpx_scale.c are declared by vpx_scale/vpx_scale_rtcd.pl,
   but is only executed if spatialResamplingSupport is enabled */
assert spatialResamplingSupport;
assert postprocVisualizerSupport -> postprocSupport;
assert (postprocVisualizerSupport && vp9Support) -> vp9PostprocSupport;
assert unitTestsSupport -> ((curl != null) && (coreutils != null));
assert vp9TemporalDenoisingSupport -> (vp9Support && temporalDenoisingSupport);
assert vp9HighbitdepthSupport -> vp9Support;
assert (experimentalSpatialSvcSupport || experimentalFpMbStatsSupport || experimentalEmulateHardwareSupport) -> experimentalSupport;
assert stdenv.isCygwin -> (unitTestsSupport && webmIOSupport && libyuvSupport);

let
  mkFlag = optSet: flag: if optSet then "--enable-${flag}" else "--disable-${flag}";
in

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "libvpx-git";

  src = fetchgit {
    url = "https://chromium.googlesource.com/webm/libvpx";
  /* DO NOT under any circumstance ever just bump the git commit without
     confirming changes have not been made to the configure system */
    rev = "f4c29ae9ea16c502c980a81ca9683327d5051929"; # 2015-2-12
    sha256 = "1d5m3dryfdrsf3mi6bcbsndyhihzksqalzfvi21fbxxkk1imsb9x";
  };

  patchPhase = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ perl yasm ];

  buildInputs = [ ]
    ++ optional unitTestsSupport coreutils
    ++ optional unitTestsSupport curl;

  configureFlags = [
    (mkFlag vp8Support "vp8")
    (mkFlag vp8EncoderSupport "vp8-encoder")
    (mkFlag vp8DecoderSupport "vp8-decoder")
    (mkFlag vp9Support "vp9")
    (mkFlag vp9EncoderSupport "vp9-encoder")
    (mkFlag vp9DecoderSupport "vp9-decoder")
    (mkFlag extraWarningsSupport "extra-warnings")
    (mkFlag werrorSupport "werror")
    "--disable-install-docs"
    (mkFlag installBinsSupport "install-bins")
    (mkFlag installLibsSupport "install-libs")
    (mkFlag installSrcsSupport "install-srcs")
    (mkFlag debugSupport "debug")
    (mkFlag gprofSupport "gprof")
    (mkFlag gcovSupport "gcov")
    # Required to build shared libraries
    (mkFlag (!stdenv.isDarwin && !stdenv.isCygwin) "pic")
    (mkFlag (stdenv.isi686 || stdenv.isx86_64) "use-x86inc")
    (mkFlag optimizationsSupport "optimizations")
    (mkFlag runtimeCpuDetectSupport "runtime-cpu-detect")
    (mkFlag thumbSupport "thumb")
    (mkFlag libsSupport "libs")
    (mkFlag examplesSupport "examples")
    "--disable-docs"
    "--as=yasm"
    # Limit default decoder max to WHXGA
    (if sizeLimitSupport then "--size-limit=5120x3200" else "")
    (mkFlag fastUnalignedSupport "fast-unaligned")
    (mkFlag codecSrcsSupport "codec-srcs")
    (mkFlag debugLibsSupport "debug-libs")
    (mkFlag stdenv.isMips "dequant-tokens")
    (mkFlag stdenv.isMips "dc-recon")
    (mkFlag postprocSupport "postproc")
    (mkFlag vp9PostprocSupport "vp9-postproc")
    (mkFlag multithreadSupport "multithread")
    (mkFlag internalStatsSupport "internal-stats")
    (mkFlag memTrackerSupport "mem-tracker")
    (mkFlag spatialResamplingSupport "spatial-resampling")
    (mkFlag realtimeOnlySupport "realtime-only")
    (mkFlag ontheflyBitpackingSupport "onthefly-bitpacking")
    (mkFlag errorConcealmentSupport "error-concealment")
    # Shared libraries are only supported on ELF platforms
    (mkFlag (stdenv.isDarwin || stdenv.isCygwin) "static")
    (mkFlag (!stdenv.isDarwin && !stdenv.isCygwin) "shared")
    (mkFlag smallSupport "small")
    (mkFlag postprocVisualizerSupport "postproc-visualizer")
    (mkFlag unitTestsSupport "unit-tests")
    (mkFlag webmIOSupport "webm-io")
    (mkFlag libyuvSupport "libyuv")
    (mkFlag decodePerfTestsSupport "decode-perf-tests")
    (mkFlag encodePerfTestsSupport "encode-perf-tests")
    (mkFlag multiResEncodingSupport "multi-res-encoding")
    (mkFlag temporalDenoisingSupport "temporal-denoising")
    (mkFlag vp9TemporalDenoisingSupport "vp9-temporal-denoising")
    (mkFlag coefficientRangeCheckingSupport "coefficient-range-checking")
    (mkFlag (vp9HighbitdepthSupport && !stdenv.isi686) "vp9-highbitdepth")
    (mkFlag experimentalSupport "experimental")
    # Experimental features
    (mkFlag experimentalSpatialSvcSupport "spatial-svc")
    (mkFlag experimentalFpMbStatsSupport "fp-mb-stats")
    (mkFlag experimentalEmulateHardwareSupport "emulate-hardware")
  ];

  enableParallelBuilding = true;

  crossAttrs = let
    isCygwin = stdenv.cross.libc == "msvcrt";
    isDarwin = stdenv.cross.libc == "libSystem";
  in {
    dontSetConfigureCross = true;
    configureFlags = configureFlags ++ [
      #"--extra-cflags="
      #"--prefix="
      #"--libc="
      #"--libdir="
      "--enable-external-build"
      # libvpx darwin targets include darwin version (ie. ARCH-darwinXX-gcc, XX being the darwin version)
      # See all_platforms: https://github.com/webmproject/libvpx/blob/master/configure
      # Darwin versions: 10.4=8, 10.5=9, 10.6=10, 10.7=11, 10.8=12, 10.9=13, 10.10=14
      "--force-target=${stdenv.cross.config}${(
              if isDarwin then (
                if      stdenv.cross.osxMinVersion == "10.10" then "14"
                else if stdenv.cross.osxMinVersion == "10.9"  then "13"
                else if stdenv.cross.osxMinVersion == "10.8"  then "12"
                else if stdenv.cross.osxMinVersion == "10.7"  then "11"
                else if stdenv.cross.osxMinVersion == "10.6"  then "10"
                else if stdenv.cross.osxMinVersion == "10.5"  then "9"
                else "8")
              else "")}-gcc"
      (if isCygwin then "--enable-static-msvcrt" else "")
    ];
  };

  meta = {
    description = "WebM VP8/VP9 codec SDK";
    homepage    = http://www.webmproject.org/;
    license     = licenses.bsd3;
    maintainers = with maintainers; [ codyopel ];
    platforms   = platforms.all;
  };
}
