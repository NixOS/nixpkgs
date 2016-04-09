{ stdenv, fetchurl, pkgconfig, perl, texinfo, yasm
, alsaLib, bzip2, fontconfig, freetype, gnutls, libiconv, lame, libass, libogg
, libtheora, libva, libvorbis, libvpx, lzma, libpulseaudio, soxr
, x264, x265, xvidcore, zlib, libopus
, openglSupport ? false, mesa ? null
# Build options
, runtimeCpuDetectBuild ? true # Detect CPU capabilities at runtime
, multithreadBuild ? true # Multithreading via pthreads/win32 threads
, sdlSupport ? !stdenv.isArm, SDL ? null
, vdpauSupport ? !stdenv.isArm, libvdpau ? null
# Developer options
, debugDeveloper ? false
, optimizationsDeveloper ? true
, extraWarningsDeveloper ? false
# Darwin frameworks
, Cocoa
# Inherit generics
, branch, sha256, version, ...
}:

/* Maintainer notes:
 *
 * THIS IS A MINIMAL BUILD OF FFMPEG, do not include dependencies unless
 * a build that depends on ffmpeg requires them to be compiled into ffmpeg,
 * see `ffmpeg-full' for an ffmpeg build with all features included.
 *
 * Need fixes to support Darwin:
 *   libvpx pulseaudio
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
  inherit (stdenv) icCygwin isDarwin isFreeBSD isLinux isArm;
  inherit (stdenv.lib) optional optionals enableFeature;

  cmpVer = builtins.compareVersions;
  reqMin = requiredVersion: (cmpVer requiredVersion branch != 1);
  reqMatch = requiredVersion: (cmpVer requiredVersion branch == 0);

  ifMinVer = minVer: flag: if reqMin minVer then flag else null;

  # Version specific fix
  verFix = withoutFix: fixVer: withFix: if reqMatch fixVer then withFix else withoutFix;

  # Disable dependency that needs fixes before it will work on Darwin or Arm
  disDarwinOrArmFix = origArg: minVer: fixArg: if ((isDarwin || isArm) && reqMin minVer) then fixArg else origArg;
in

assert openglSupport -> mesa != null;

stdenv.mkDerivation rec {

  name = "ffmpeg-${version}";
  inherit version;

  src = fetchurl {
    url = "https://www.ffmpeg.org/releases/${name}.tar.bz2";
    inherit sha256;
  };

  patchPhase = ''patchShebangs .'';

  configureFlags = [
    # License
      "--enable-gpl"
      "--enable-version3"
    # Build flags
      "--enable-shared"
      "--disable-static"
      (ifMinVer "0.6" "--enable-pic")
      (enableFeature runtimeCpuDetectBuild "runtime-cpudetect")
      "--enable-hardcoded-tables"
      (if multithreadBuild then (
         if stdenv.isCygwin then
           "--disable-pthreads --enable-w32threads"
         else # Use POSIX threads by default
           "--enable-pthreads --disable-w32threads")
       else
         "--disable-pthreads --disable-w32threads")
      (ifMinVer "0.9" "--disable-os2threads") # We don't support OS/2
      "--enable-network"
      (ifMinVer "2.4" "--enable-pixelutils")
    # Executables
      "--enable-ffmpeg"
      "--disable-ffplay"
      (ifMinVer "0.6" "--enable-ffprobe")
      "--disable-ffserver"
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
      "--enable-bzlib"
      "--enable-gnutls"
      (ifMinVer "1.0" "--enable-fontconfig")
      (ifMinVer "0.7" "--enable-libfreetype")
      "--enable-libmp3lame"
      (ifMinVer "1.2" "--enable-iconv")
      "--enable-libtheora"
      (ifMinVer "0.6" (enableFeature (isLinux || isFreeBSD) "vaapi"))
      "--enable-vdpau"
      "--enable-libvorbis"
      (disDarwinOrArmFix (ifMinVer "0.6" "--enable-libvpx") "0.6" "--disable-libvpx")
      (ifMinVer "2.4" "--enable-lzma")
      (ifMinVer "2.2" (enableFeature openglSupport "opengl"))
      (disDarwinOrArmFix (ifMinVer "0.9" "--enable-libpulse") "0.9" "--disable-libpulse")
      (ifMinVer "2.5" (if sdlSupport then "--enable-sdl" else "")) # Only configurable since 2.5, auto detected before then
      (ifMinVer "1.2" "--enable-libsoxr")
      "--enable-libx264"
      "--enable-libxvid"
      "--enable-zlib"
      (ifMinVer "2.8" "--enable-libopus")
      (ifMinVer "2.8" "--enable-libx265")
    # Developer flags
      (enableFeature debugDeveloper "debug")
      (enableFeature optimizationsDeveloper "optimizations")
      (enableFeature extraWarningsDeveloper "extra-warnings")
      "--disable-stripping"
    # Disable mmx support for 0.6.90
      (verFix null "0.6.90" "--disable-mmx")
  ] ++ optional stdenv.cc.isClang "--cc=clang";

  nativeBuildInputs = [ perl pkgconfig texinfo yasm ];

  buildInputs = [
    bzip2 fontconfig freetype gnutls libiconv lame libass libogg libtheora
    libvdpau libvorbis lzma SDL soxr x264 x265 xvidcore zlib libopus
  ] ++ optional openglSupport mesa
    ++ optionals (!isDarwin && !isArm) [ libvpx libpulseaudio ] # Need to be fixed on Darwin and ARM
    ++ optional ((isLinux || isFreeBSD) && !isArm) libva
    ++ optional isLinux alsaLib
    ++ optional isDarwin Cocoa
    ++ optional vdpauSupport libvdpau
    ++ optional sdlSupport SDL;


  enableParallelBuilding = true;

  /* Cross-compilation is untested, consider this an outline, more work
     needs to be done to portions of the build to get it to work correctly */
  crossAttrs = let
    os = ''
      if [ "${stdenv.cross.config}" = "*cygwin*" ] ; then
        # Probably should look for mingw too
        echo "cygwin"
      elif [ "${stdenv.cross.config}" = "*darwin*" ] ; then
        echo "darwin"
      elif [ "${stdenv.cross.config}" = "*freebsd*" ] ; then
        echo "freebsd"
      elif [ "${stdenv.cross.config}" = "*linux*" ] ; then
        echo "linux"
      elif [ "${stdenv.cross.config}" = "*netbsd*" ] ; then
        echo "netbsd"
      elif [ "${stdenv.cross.config}" = "*openbsd*" ] ; then
        echo "openbsd"
      fi
    '';
  in {
    dontSetConfigureCross = true;
    configureFlags = configureFlags ++ [
      "--cross-prefix=${stdenv.cross.config}-"
      "--enable-cross-compile"
      "--target_os=${os}"
      "--arch=${stdenv.cross.arch}"
    ];
  };

  passthru = {
    vaapiSupport = if reqMin "0.6" && ((isLinux || isFreeBSD) && !isArm) then true else false;
    inherit vdpauSupport;
  };

  meta = with stdenv.lib; {
    description = "A complete, cross-platform solution to record, convert and stream audio and video";
    homepage = http://www.ffmpeg.org/;
    longDescription = ''
      FFmpeg is the leading multimedia framework, able to decode, encode, transcode, 
      mux, demux, stream, filter and play pretty much anything that humans and machines 
      have created. It supports the most obscure ancient formats up to the cutting edge. 
      No matter if they were designed by some standards committee, the community or 
      a corporation. 
    '';
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ codyopel fuuzetsu ];
    inherit branch;
  };
}
