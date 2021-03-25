{ lib, stdenv, buildPackages, fetchurl, pkg-config, addOpenGLRunpath, perl, texinfo, yasm
, alsaLib, bzip2, fontconfig, freetype, gnutls, libiconv, lame, libass, libogg
, libssh, libtheora, libva, libdrm, libvorbis, libvpx, lzma, libpulseaudio, soxr
, x264, x265, xvidcore, zlib, libopus, speex, nv-codec-headers, dav1d
, openglSupport ? false, libGLU ? null, libGL ? null
, libmfxSupport ? false, intel-media-sdk ? null
, libaomSupport ? false, libaom ? null
# Build options
, runtimeCpuDetectBuild ? true # Detect CPU capabilities at runtime
, multithreadBuild ? true # Multithreading via pthreads/win32 threads
, sdlSupport ? !stdenv.isAarch32, SDL ? null, SDL2 ? null
, vdpauSupport ? !stdenv.isAarch32, libvdpau ? null
# Developer options
, debugDeveloper ? false
, optimizationsDeveloper ? true
, extraWarningsDeveloper ? false
# Darwin frameworks
, Cocoa, darwinFrameworks ? [ Cocoa ]
# Inherit generics
, branch, sha256, version, patches ? [], ...
}:

/* Maintainer notes:
 *
 * THIS IS A MINIMAL BUILD OF FFMPEG, do not include dependencies unless
 * a build that depends on ffmpeg requires them to be compiled into ffmpeg,
 * see `ffmpeg-full' for an ffmpeg build with all features included.
 *
 * Need fixes to support Darwin:
 *   pulseaudio
 *
 * Known issues:
 * 0.6     - fails to compile (unresolved) (so far, only disabling a number of
 *           features works, but that is not a feasible solution)
 * 0.6.90  - mmx: compile errors (fix: disable for 0.6.90-rc0)
 * 1.1     - libsoxr: compile error (fix: disable for 1.1)
 *           Support was initially added in 1.1 before soxr api change, fix
 *           would probably be to add soxr-1.0
 * ALL     - Cross-compiling will disable features not present on host OS
 *           (e.g. dxva2 support [DirectX] will not be enabled unless natively
 *           compiled on Cygwin)
 *
 */

let
  inherit (stdenv) isDarwin isFreeBSD isLinux isAarch32;
  inherit (lib) optional optionals optionalString enableFeature filter;

  cmpVer = builtins.compareVersions;
  reqMin = requiredVersion: (cmpVer requiredVersion branch != 1);
  reqMatch = requiredVersion: (cmpVer requiredVersion branch == 0);

  ifMinVer = minVer: flag: if reqMin minVer then flag else null;

  # Version specific fix
  verFix = withoutFix: fixVer: withFix: if reqMatch fixVer then withFix else withoutFix;

  # Disable dependency that needs fixes before it will work on Darwin or Arm
  disDarwinOrArmFix = origArg: minVer: fixArg: if ((isDarwin || isAarch32) && reqMin minVer) then fixArg else origArg;

  vaapiSupport = reqMin "0.6" && ((isLinux || isFreeBSD) && !isAarch32);

  vpxSupport = reqMin "0.6" && !isAarch32;
in

assert openglSupport -> libGL != null && libGLU != null;
assert libmfxSupport -> intel-media-sdk != null;
assert libaomSupport -> libaom != null;

stdenv.mkDerivation rec {

  pname = "ffmpeg";
  inherit version;

  src = fetchurl {
    url = "https://www.ffmpeg.org/releases/${pname}-${version}.tar.bz2";
    inherit sha256;
  };

  postPatch = "patchShebangs .";
  inherit patches;

  outputs = [ "bin" "dev" "out" "man" ]
    ++ optional (reqMin "1.0") "doc" ; # just dev-doc
  setOutputFlags = false; # doesn't accept all and stores configureFlags in libs!

  configurePlatforms = [];
  configureFlags = filter (v: v != null) ([
      "--arch=${stdenv.hostPlatform.parsed.cpu.name}"
      "--target_os=${stdenv.hostPlatform.parsed.kernel.name}"
    # License
      "--enable-gpl"
      "--enable-version3"
    # Build flags
      "--enable-shared"
      (ifMinVer "0.6" "--enable-pic")
      (enableFeature runtimeCpuDetectBuild "runtime-cpudetect")
      "--enable-hardcoded-tables"
    ] ++
      (if multithreadBuild then (
         if stdenv.isCygwin then
           ["--disable-pthreads" "--enable-w32threads"]
         else # Use POSIX threads by default
           ["--enable-pthreads" "--disable-w32threads"])
       else
         ["--disable-pthreads" "--disable-w32threads"])
    ++ [
      (ifMinVer "0.9" "--disable-os2threads") # We don't support OS/2
      "--enable-network"
      (ifMinVer "2.4" "--enable-pixelutils")
    # Executables
      "--enable-ffmpeg"
      "--disable-ffplay"
      (ifMinVer "0.6" "--enable-ffprobe")
      (if reqMin "4" then null else "--disable-ffserver")
    # Libraries
      (ifMinVer "0.6" "--enable-avcodec")
      (ifMinVer "0.6" "--enable-avdevice")
      "--enable-avfilter"
      (ifMinVer "0.6" "--enable-avformat")
      (ifMinVer "1.0" "--enable-avresample")
      (ifMinVer "1.1" "--enable-avutil")
      "--enable-postproc"
      (ifMinVer "0.9" "--enable-swresample")
      "--enable-swscale"
    # Docs
      (ifMinVer "0.6" "--disable-doc")
    # External Libraries
      "--enable-libass"
      "--enable-bzlib"
      "--enable-gnutls"
      (ifMinVer "1.0" "--enable-fontconfig")
      (ifMinVer "0.7" "--enable-libfreetype")
      "--enable-libmp3lame"
      (ifMinVer "1.2" "--enable-iconv")
      "--enable-libtheora"
      (ifMinVer "2.1" "--enable-libssh")
      (ifMinVer "0.6" (enableFeature vaapiSupport "vaapi"))
      (ifMinVer "3.4" (enableFeature vaapiSupport "libdrm"))
      (enableFeature vdpauSupport "vdpau")
      "--enable-libvorbis"
      (ifMinVer "0.6" (enableFeature vpxSupport "libvpx"))
      (ifMinVer "2.4" "--enable-lzma")
      (ifMinVer "2.2" (enableFeature openglSupport "opengl"))
      (ifMinVer "4.2" (enableFeature libmfxSupport "libmfx"))
      (ifMinVer "4.2" (enableFeature libaomSupport "libaom"))
      (disDarwinOrArmFix (ifMinVer "0.9" "--enable-libpulse") "0.9" "--disable-libpulse")
      (ifMinVer "2.5" (if sdlSupport && reqMin "3.2" then "--enable-sdl2" else if sdlSupport then "--enable-sdl" else null)) # autodetected before 2.5, SDL1 support removed in 3.2 for SDL2
      (ifMinVer "1.2" "--enable-libsoxr")
      "--enable-libx264"
      "--enable-libxvid"
      "--enable-zlib"
      (ifMinVer "2.8" "--enable-libopus")
      "--enable-libspeex"
      (ifMinVer "2.8" "--enable-libx265")
      (ifMinVer "4.2" (enableFeature (dav1d != null) "libdav1d"))
    # Developer flags
      (enableFeature debugDeveloper "debug")
      (enableFeature optimizationsDeveloper "optimizations")
      (enableFeature extraWarningsDeveloper "extra-warnings")
      "--disable-stripping"
    # Disable mmx support for 0.6.90
      (verFix null "0.6.90" "--disable-mmx")
  ] ++ optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      "--cross-prefix=${stdenv.cc.targetPrefix}"
      "--enable-cross-compile"
  ] ++ optional stdenv.cc.isClang "--cc=clang");

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ addOpenGLRunpath perl pkg-config texinfo yasm ];

  buildInputs = [
    bzip2 fontconfig freetype gnutls libiconv lame libass libogg libssh libtheora
    libvorbis lzma soxr x264 x265 xvidcore zlib libopus speex nv-codec-headers
  ] ++ optionals openglSupport [ libGL libGLU ]
    ++ optional libmfxSupport intel-media-sdk
    ++ optional libaomSupport libaom
    ++ optional vpxSupport libvpx
    ++ optionals (!isDarwin && !isAarch32) [ libpulseaudio ] # Need to be fixed on Darwin and ARM
    ++ optional ((isLinux || isFreeBSD) && !isAarch32) libva
    ++ optional ((isLinux || isFreeBSD) && !isAarch32) libdrm
    ++ optional isLinux alsaLib
    ++ optionals isDarwin darwinFrameworks
    ++ optional vdpauSupport libvdpau
    ++ optional sdlSupport (if reqMin "3.2" then SDL2 else SDL)
    ++ optional (reqMin "4.2") dav1d;

  enableParallelBuilding = true;

  doCheck = false; # fails

  # ffmpeg 3+ generates pkg-config (.pc) files that don't have the
  # form automatically handled by the multiple-outputs hooks.
  postFixup = ''
    moveToOutput bin "$bin"
    moveToOutput share/ffmpeg/examples "$doc"
    for pc in ''${!outputDev}/lib/pkgconfig/*.pc; do
      substituteInPlace $pc \
        --replace "includedir=$out" "includedir=''${!outputInclude}"
    done
  '' + optionalString stdenv.isLinux ''
    # Set RUNPATH so that libnvcuvid and libcuda in /run/opengl-driver(-32)/lib can be found.
    # See the explanation in addOpenGLRunpath.
    addOpenGLRunpath $out/lib/libavcodec.so
    addOpenGLRunpath $out/lib/libavutil.so
  '';

  installFlags = [ "install-man" ];

  passthru = {
    inherit vaapiSupport vdpauSupport;
  };

  meta = with lib; {
    description = "A complete, cross-platform solution to record, convert and stream audio and video";
    homepage = "http://www.ffmpeg.org/";
    longDescription = ''
      FFmpeg is the leading multimedia framework, able to decode, encode, transcode,
      mux, demux, stream, filter and play pretty much anything that humans and machines
      have created. It supports the most obscure ancient formats up to the cutting edge.
      No matter if they were designed by some standards committee, the community or
      a corporation.
    '';
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ codyopel ];
    inherit branch;
  };
}
