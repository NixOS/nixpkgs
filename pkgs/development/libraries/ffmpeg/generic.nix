{ lib, stdenv, buildPackages, fetchurl, pkg-config, addOpenGLRunpath, perl, texinfo, yasm
, alsa-lib, bzip2, fontconfig, freetype, gnutls, libiconv, lame, libass, libogg
, libssh, libtheora, libva, libdrm, libvorbis, xz, soxr
, x264, x265, xvidcore, zimg, zlib, libopus, speex, nv-codec-headers, dav1d
, vpxSupport ? !stdenv.isAarch32, libvpx
, srtSupport ? true, srt
, vaapiSupport ? ((stdenv.isLinux || stdenv.isFreeBSD) && !stdenv.isAarch32)
, openglSupport ? false, libGLU, libGL
, libmfxSupport ? false, intel-media-sdk
, libaomSupport ? false, libaom
# Build options
, runtimeCpuDetectBuild ? true # Detect CPU capabilities at runtime
, multithreadBuild ? true # Multithreading via pthreads/win32 threads
, sdlSupport ? !stdenv.isAarch32, SDL2
, vdpauSupport ? !stdenv.isAarch32, libvdpau
# Developer options
, debugDeveloper ? false
, optimizationsDeveloper ? true
, extraWarningsDeveloper ? false
, Cocoa, CoreMedia, VideoToolbox
# Inherit generics
, branch, sha256, version, patches ? [], knownVulnerabilities ? []
, doCheck ? true
, pulseaudioSupport ? stdenv.isLinux
, libpulseaudio
, ...
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
 * ALL     - Cross-compiling will disable features not present on host OS
 *           (e.g. dxva2 support [DirectX] will not be enabled unless natively
 *           compiled on Cygwin)
 *
 */

let
  inherit (lib) optional optionals optionalString enableFeature filter;

  reqMin = requiredVersion: (builtins.compareVersions requiredVersion branch != 1);

  ifMinVer = minVer: flag: if reqMin minVer then flag else null;

  ifVerOlder = maxVer: flag: if (lib.versionOlder branch maxVer) then flag else null;
in

stdenv.mkDerivation rec {
  pname = "ffmpeg";
  inherit version;

  src = fetchurl {
    url = "https://www.ffmpeg.org/releases/${pname}-${version}.tar.bz2";
    inherit sha256;
  };

  postPatch = "patchShebangs .";
  inherit patches;

  outputs = [ "bin" "dev" "out" "man" "doc" ];
  setOutputFlags = false; # doesn't accept all and stores configureFlags in libs!

  configurePlatforms = [];
  configureFlags = filter (v: v != null) ([
      "--arch=${stdenv.hostPlatform.parsed.cpu.name}"
      "--target_os=${stdenv.hostPlatform.parsed.kernel.name}"
      "--pkg-config=${pkg-config.targetPrefix}pkg-config"
    # License
      "--enable-gpl"
      "--enable-version3"
    # Build flags
      "--enable-shared"
      "--enable-pic"
      (ifMinVer "4.0" (enableFeature srtSupport "libsrt"))
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
      "--disable-os2threads" # We don't support OS/2
      "--enable-network"
      "--enable-pixelutils"
    # Executables
      "--enable-ffmpeg"
      "--disable-ffplay"
      "--enable-ffprobe"
      (ifVerOlder "4" "--disable-ffserver")
    # Libraries
      "--enable-avcodec"
      "--enable-avdevice"
      "--enable-avfilter"
      "--enable-avformat"
      (ifVerOlder "5.0" "--enable-avresample")
      "--enable-avutil"
      "--enable-postproc"
      "--enable-swresample"
      "--enable-swscale"
    # Docs
      "--disable-doc"
    # External Libraries
      "--enable-libass"
      "--enable-bzlib"
      "--enable-gnutls"
      "--enable-fontconfig"
      "--enable-libfreetype"
      "--enable-libmp3lame"
      "--enable-iconv"
      "--enable-libtheora"
      "--enable-libssh"
      (enableFeature vaapiSupport "vaapi")
      (enableFeature vaapiSupport "libdrm")
      (enableFeature vdpauSupport "vdpau")
      "--enable-libvorbis"
      (enableFeature vpxSupport "libvpx")
      "--enable-lzma"
      (enableFeature openglSupport "opengl")
      (ifMinVer "4.2" (enableFeature libmfxSupport "libmfx"))
      (ifMinVer "4.2" (enableFeature libaomSupport "libaom"))
      (lib.optionalString pulseaudioSupport "--enable-libpulse")
      (enableFeature sdlSupport "sdl2")
      "--enable-libsoxr"
      "--enable-libx264"
      "--enable-libxvid"
      "--enable-libzimg"
      "--enable-zlib"
      "--enable-libopus"
      "--enable-libspeex"
      "--enable-libx265"
      (ifMinVer "4.2" (enableFeature (reqMin "4.2") "libdav1d"))
    # Developer flags
      (enableFeature debugDeveloper "debug")
      (enableFeature optimizationsDeveloper "optimizations")
      (enableFeature extraWarningsDeveloper "extra-warnings")
      "--disable-stripping"
  ] ++ optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      "--cross-prefix=${stdenv.cc.targetPrefix}"
      "--enable-cross-compile"
  ] ++ optional stdenv.cc.isClang "--cc=clang");

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ addOpenGLRunpath perl pkg-config texinfo yasm ];

  buildInputs = [
    bzip2 fontconfig freetype gnutls libiconv lame libass libogg libssh libtheora
    libvorbis xz soxr x264 x265 xvidcore zimg zlib libopus speex nv-codec-headers
  ] ++ optionals openglSupport [ libGL libGLU ]
    ++ optional libmfxSupport intel-media-sdk
    ++ optional libaomSupport libaom
    ++ optional vpxSupport libvpx
    ++ optionals (!stdenv.isDarwin && pulseaudioSupport) [ libpulseaudio ] # Need to be fixed on Darwin
    ++ optionals vaapiSupport [ libva libdrm ]
    ++ optional stdenv.isLinux alsa-lib
    ++ optionals stdenv.isDarwin [ Cocoa CoreMedia VideoToolbox ]
    ++ optional vdpauSupport libvdpau
    ++ optional sdlSupport SDL2
    ++ optional srtSupport srt
    ++ optional (reqMin "4.2") dav1d;

  enableParallelBuilding = true;

  inherit doCheck;
  checkPhase = let
    ldLibraryPathEnv = if stdenv.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
  in ''
    ${ldLibraryPathEnv}="libavcodec:libavdevice:libavfilter:libavformat:libavresample:libavutil:libpostproc:libswresample:libswscale:''${${ldLibraryPathEnv}}" \
      make check -j$NIX_BUILD_CORES
  '';

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
    homepage = "https://www.ffmpeg.org/";
    changelog = "https://github.com/FFmpeg/FFmpeg/blob/n${version}/Changelog";
    longDescription = ''
      FFmpeg is the leading multimedia framework, able to decode, encode, transcode,
      mux, demux, stream, filter and play pretty much anything that humans and machines
      have created. It supports the most obscure ancient formats up to the cutting edge.
      No matter if they were designed by some standards committee, the community or
      a corporation.
    '';
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
    inherit branch knownVulnerabilities;
  };
}
