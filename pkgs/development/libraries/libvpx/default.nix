{stdenv, fetchurl, bash, perl, yasm
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
, optimizationsSupport ? true # compiler optimization flags
, runtimeCpuDetectSupport ? true # detect cpu capabilities at runtime
, thumbSupport ? false # build arm assembly in thumb mode
, libsSupport ? true # build librares
, examplesSupport ? true # build examples (vpxdec & vpxenc are part of examples)
, fastUnalignedSupport ? true # use unaligned accesses if supported by hardware
, codecSrcsSupport ? false # codec library source code
, debugLibsSupport ? false # include debug version of each library
, md5Support ? true # support for output of checksum data
, postprocSupport ? true # postprocessing
, vp9PostprocSupport ? true # VP9 specific postprocessing
, multithreadSupport ? true # multithreaded decoding & encoding
, internalStatsSupport ? false # output of encoder internal stats for debug, if supported (encoders)
, memTrackerSupport ? false # track memory usage
, realtimeOnlySupport ? false # build for real-time encoding
, ontheflyBitpackingSupport ? false # on-the-fly bitpacking in real-time encoding
, errorConcealmentSupport ? false # decoder conceals losses
, smallSupport ? false # favor smaller binary over speed
, postprocVisualizerSupport ? false # macro block/block level visualizers
, unitTestsSupport ? false, curl ? null, coreutils ? null # unit tests
, multiResEncodingSupport ? false # multiple-resolution encoding
, temporalDenoisingSupport ? true # use temporal denoising instead of spatial denoising
, decryptSupport ? false
, experimentalSupport ? false # experimental features
# Experimental features
, experimentalMultipleArfSupport ? false
, experimentalNon420Support ? false
, experimentalAlphaSupport ? false
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
assert examplesSupport -> md5Support;
assert vp9PostprocSupport -> (vp9Support && postprocSupport);
assert (internalStatsSupport && vp9Support) -> vp9PostprocSupport;
assert postprocVisualizerSupport -> postprocSupport;
assert (postprocVisualizerSupport && vp9Support) -> vp9PostprocSupport;
assert unitTestsSupport -> ((curl != null) && (coreutils != null));
assert (experimentalMultipleArfSupport || experimentalNon420Support || experimentalAlphaSupport) -> experimentalSupport;
assert stdenv.isCygwin -> unitTestsSupport;

let
  mkFlag = optSet: flag: if optSet then "--enable-${flag}" else "--disable-${flag}";
in

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "libvpx-${version}";
  version = "1.3.0";

  src = fetchurl {
    url = "http://webm.googlecode.com/files/libvpx-v${version}.tar.bz2";
    sha1 = "191b95817aede8c136cc3f3745fb1b8c50e6d5dc";
  };

  patchPhase = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ bash perl yasm ];

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
    (mkFlag (stdenv.isx86_64 || !stdenv.isDarwin || stdenv.isCygwin) "use-x86inc")
    (mkFlag optimizationsSupport "optimizations")
    (mkFlag runtimeCpuDetectSupport "runtime-cpu-detect")
    (mkFlag thumbSupport "thumb")
    (mkFlag libsSupport "libs")
    (mkFlag examplesSupport "examples")
    "--disable-docs"
    "--as=yasm"
    (mkFlag fastUnalignedSupport "fast-unaligned")
    (mkFlag codecSrcsSupport "codec-srcs")
    (mkFlag debugLibsSupport "debug-libs")
    (mkFlag md5Support "md5")
    (mkFlag stdenv.isMips "dequant-tokens")
    (mkFlag stdenv.isMips "dc-recon")
    (mkFlag postprocSupport "postproc")
    (mkFlag vp9PostprocSupport "vp9-postproc")
    (mkFlag multithreadSupport "multithread")
    (mkFlag internalStatsSupport "internal-stats")
    (mkFlag memTrackerSupport "mem-tracker")
    /* If --enable-spatial-resampling not enabled, build will fail with undeclared variable errors.
       Variables called in vpx_scale/generic/vpx_scale.c are declared by vpx_scale/vpx_scale_rtcd.pl,
       but is only executed if --enable-spatial-resampling is enabled */
    "--enable-spatial-resampling"
    (mkFlag realtimeOnlySupport "realtime-only")
    (mkFlag ontheflyBitpackingSupport "onthefly-bitpacking")
    (mkFlag errorConcealmentSupport "error-concealment")
    # Shared libraries are only supported on ELF platforms
    (mkFlag (stdenv.isDarwin || stdenv.isCygwin) "static")
    (mkFlag (!stdenv.isDarwin && !stdenv.isCygwin) "shared")
    (mkFlag smallSupport "small")
    (mkFlag postprocVisualizerSupport "postproc-visualizer")
    (mkFlag unitTestsSupport "unit-tests")
    (mkFlag multiResEncodingSupport "multi-res-encoding")
    (mkFlag temporalDenoisingSupport "temporal-denoising")
    (mkFlag decryptSupport "decrypt")
    (mkFlag experimentalSupport "experimental")
    # Experimental features
    (mkFlag experimentalMultipleArfSupport "multiple-arf")
    (mkFlag experimentalNon420Support "non420")
    (mkFlag experimentalAlphaSupport "alpha")
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
                if stdenv.cross.osxMinVersion == "10.9"  then "13"
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
    maintainers = with maintainers; [ codyopel lovek323 ];
    platforms   = platforms.all;
  };
}
