{ stdenv, fetchurl, pkgconfig, perl, texinfo, yasm
/*
 *  Licensing options (yes some are listed twice, filters and such are not listed)
 */
, gplLicensing ? true # GPL: fdkaac,openssl,frei0r,cdio,samba,utvideo,vidstab,x265,x265,xavs,avid,zvbi,x11grab
, version3Licensing ? true # (L)GPL3: opencore-amrnb,opencore-amrwb,samba,vo-aacenc,vo-amrwbenc
, nonfreeLicensing ? false # NONFREE: openssl,fdkaac,faac,aacplus,blackmagic-design-desktop-video
/*
 *  Build options
 */
, smallBuild ? false # Optimize for size instead of speed
, runtime-cpudetectBuild ? true # Detect CPU capabilities at runtime (disable to compile natively)
, grayBuild ? true # Full grayscale support
, swscale-alphaBuild ? true # Alpha channel support in swscale
, incompatible-libav-abiBuild ? false # Incompatible Libav fork ABI
, hardcoded-tablesBuild ? true # Hardcode decode tables instead of runtime generation
, safe-bitstream-readerBuild ? true # Buffer boundary checking in bitreaders
, memalign-hackBuild ? false # Emulate memalign
, multithreadBuild ? true # Multithreading via pthreads/win32 threads
, networkBuild ? true # Network support
, pixelutilsBuild ? true # Pixel utils in libavutil
/*
 *  Program options
 */
, ffmpegProgram ? true # Build ffmpeg executable
, ffplayProgram ? true # Build ffplay executable
, ffprobeProgram ? true # Build ffprobe executable
, ffserverProgram ? true # Build ffserver executable
, qt-faststartProgram ? true # Build qt-faststart executable
/*
 *  Library options
 */
, avcodecLibrary ? true # Build avcodec library
, avdeviceLibrary ? true # Build avdevice library
, avfilterLibrary ? true # Build avfilter library
, avformatLibrary ? true # Build avformat library
, avresampleLibrary ? true # Build avresample library
, avutilLibrary ? true # Build avutil library
, postprocLibrary ? true # Build postproc library
, swresampleLibrary ? true # Build swresample library
, swscaleLibrary ? true # Build swscale library
/*
 *  Documentation options
 */
, htmlpagesDocumentation ? false # HTML documentation pages
, manpagesDocumentation ? true # Man documentation pages
, podpagesDocumentation ? false # POD documentation pages
, txtpagesDocumentation ? false # Text documentation pages
/*
 *  External libraries options
 */
#, aacplusExtlib ? false, aacplus ? null # AAC+ encoder
, alsaLib ? null # Alsa in/output support
#, avisynth ? null # Support for reading AviSynth scripts
, bzip2 ? null
, celt ? null # CELT decoder
#, crystalhd ? null # Broadcom CrystalHD hardware acceleration
#, decklinkExtlib ? false, blackmagic-design-desktop-video ? null # Blackmagic Design DeckLink I/O support
, faacExtlib ? false, faac ? null # AAC encoder
, faad2Extlib ? false, faad2 ? null # AAC decoder - DEPRECATED
, fdk-aacExtlib ? false, fdk_aac ? null # Fraunhofer FDK AAC de/encoder
#, flite ? null # Flite (voice synthesis) support
, fontconfig ? null # Needed for drawtext filter
, freetype ? null # Needed for drawtext filter
, frei0r ? null # frei0r video filtering
, fribidi ? null # Needed for drawtext filter
#, game-music-emu ? null # Game Music Emulator
, gnutls ? null
#, gsm ? null # GSM de/encoder
#, ilbc ? null # iLBC de/encoder
#, jack2 ? null # Jack audio (only version 2 is supported in this build)
, ladspaH ? null # LADSPA audio filtering
, lame ? null # LAME MP3 encoder
, libass ? null # (Advanced) SubStation Alpha subtitle rendering
, libbluray ? null # BluRay reading
, libbs2b ? null # bs2b DSP library
#, libcaca ? null # Textual display (ASCII art)
#, libcdio-paranoia ? null # Audio CD grabbing
, libdc1394 ? null, libraw1394 ? null # IIDC-1394 grabbing (ieee 1394)
, libiconv ? null
#, libiec61883 ? null, libavc1394 ? null # iec61883 (also uses libraw1394)
#, libmfx ? null # Hardware acceleration vis libmfx
, libmodplug ? null # ModPlug support
#, libnut ? null # NUT (de)muxer, native (de)muser exists
, libogg ? null # Ogg container used by vorbis & theora
, libopus ? null # Opus de/encoder
, libsndio ? null # sndio playback/record support
, libssh ? null # SFTP protocol
, libtheora ? null # Theora encoder
, libva ? null # Vaapi hardware acceleration
, libvdpau ? null # Vdpau hardware acceleration
, libvorbis ? null # Vorbis de/encoding, native encoder exists
, libvpx ? null # VP8 & VP9 de/encoding
, libwebp ? null # WebP encoder
, libX11 ? null # Xlib support
, libxcb ? null # X11 grabbing using XCB
, libxcb-shmExtlib ? true # X11 grabbing shm communication
, libxcb-xfixesExtlib ? true # X11 grabbing mouse rendering
, libxcb-shapeExtlib ? true # X11 grabbing shape rendering
, libXv ? null # Xlib support
, lzma ? null # xz-utils
#, nvenc ? null # NVIDIA NVENC support
#, openal ? null # OpenAL 1.1 capture support
#, opencl ? null # OpenCL code
#, opencore-amr ? null # AMR-NB de/encoder & AMR-WB decoder
#, opencv ? null # Video filtering
, openglExtlib ? false, mesa ? null # OpenGL rendering
#, openh264 ? null # H.264/AVC encoder
, openjpeg_1 ? null # JPEG 2000 de/encoder
, opensslExtlib ? false, openssl ? null
, pulseaudio ? null # Pulseaudio input support
, rtmpdump ? null # RTMP[E] support
#, libquvi ? null # Quvi input support
, sambaExtlib ? false, samba ? null # Samba protocol
#, schroedinger ? null # Dirac de/encoder
, SDL ? null
#, shine ? null # Fixed-point MP3 encoder
, soxr ? null # Resampling via soxr
, speex ? null # Speex de/encoder
#, twolame ? null # MP2 encoder
#, utvideo ? null # Ut Video de/encoder
, v4l_utils ? null # Video 4 Linux support
, vid-stab ? null # Video stabilization
#, vo-aacenc ? null # AAC encoder
#, vo-amrwbenc ? null # AMR-WB encoder
, wavpack ? null # Wavpack encoder
, x11grabExtlib ? false, libXext ? null, libXfixes ? null # X11 grabbing (legacy)
, x264 ? null # H.264/AVC encoder
, x265 ? null # H.265/HEVC encoder
#, xavs ? null # AVS encoder
, xvidcore ? null # Xvid encoder, native encoder exists
#, zeromq4 ? null # Message passing
, zlib ? null
#, zvbi ? null # Teletext support
/*
 *  Developer options
 */
, debugDeveloper ? false
, optimizationsDeveloper ? true
, extra-warningsDeveloper ? false
, strippingDeveloper ? false
/*
 *  Inherit generics
 */
, branch, sha256, version, ...
}:

/* Maintainer notes:
 *
 * Version bumps:
 * It should always be safe to bump patch releases (e.g. 2.1.x, x being a patch release)
 * If adding a new branch, note any configure flags that were added, changed, or deprecated/removed
 *   and make the necessary changes.
 *
 * En/disabling in/outdevs was added in 0.6
 *
 * Packages with errors:
 *   flite ilbc schroedinger
 *   opencv - circular dependency issue
 *
 * Not packaged:
 *   aacplus avisynth cdio-paranoia crystalhd libavc1394 libiec61883
 *   libmxf libnut libquvi nvenc opencl opencore-amr openh264 oss shine twolame
 *   utvideo vo-aacenc vo-amrwbenc xvmc zvbi blackmagic-design-desktop-video
 *
 * Need fixes to support Darwin:
 *   frei0r, game-music-emu, gsm, jack2, libssh, libvpx(stable 1.3.0), openal, openjpeg_1,
 *   pulseaudio, rtmpdump, samba, vit-stab, wavpack, x265. xavs
 *
 * Not supported:
 *   stagefright-h264(android only)
 *
 * Known issues:
 * 0.5     - libgsm: configure fails to find library (fix: disable for 0.5)
 * 0.5-0.8 - qt-quickstart: make error (fix: disable for 0.5-0.8)
 * 0.6     - fails to compile (unresolved) (so far, only disabling a number of features
 *           works, but that is not a feasible solution)
 * 0.6.90  - mmx: compile errors (fix: disable for 0.6.90-rc0)
 * 0.7-1.1 - opencv: compile error, flag added in 0.7 (fix: disable for 0.7-1.1)
 * 1.1     - libsoxr: compile error (fix: disable for 1.1)
 *           Support was initially added in 1.1 before soxr api change, fix would probably be to add soxr-1.0
 * 2.0-2.1 - vid-stab: compile errors, flag added in 2.0 (fix: disable for 2.0-2.1)
 *           Recent changes (circa 2014) more than likely broke compatibility and a fix has not been back ported
 * ALL     - flite: configure fails to find library (tested against 1.4 & 1.9 & 2.0)
 *           Tried modifying configure and flite to use pkg-config
 * ALL     - Cross-compiling will disable features not present on host OS
 *           (e.g. dxva2 support [DirectX] will not be enabled unless natively compiled on Cygwin)
 *
 */

let
  # Minimum/maximun/matching version
  cmpVer = builtins.compareVersions;
  reqMin = requiredVersion: (cmpVer requiredVersion branch != 1);
  reqMax = requiredVersion: (cmpVer branch requiredVersion != 1);
  reqMatch = requiredVersion: (cmpVer requiredVersion branch == 0);

  # Configure flag
  mkFlag = optSet: minVer: flag: if reqMin minVer then (
                                   if optSet then "--enable-${flag}" else "--disable-${flag}")
                                 else null;
  # Deprecated configure flag (e.g. faad2)
  depFlag = optSet: minVer: maxVer: flag: if reqMin minVer && reqMax maxVer then mkFlag optSet minVer flag else null;

  # Version specific fix
  verFix = withoutFix: fixVer: withFix: if reqMatch fixVer then withFix else withoutFix;

  # Flag change between versions (e.g. "--enable-armvfp" -> "--enable-vfp" changed in v1.1)
  chgFlg = chgVer: oldFlag: newFlag: if reqMin chgVer then newFlag else oldFlag;

  # Disable dependency that needs fixes before it will work on Darwin
  disDarwinFix = origArg: if stdenv.isDarwin then false else origArg;

  isCygwin = stdenv.isCygwin;
  isDarwin = stdenv.isDarwin;
  isLinux = stdenv.isLinux;
in

/*
 *  Licensing dependencies
 */
assert version3Licensing && reqMin "0.5" -> gplLicensing;
assert nonfreeLicensing && reqMin "0.5" -> gplLicensing && version3Licensing;
/*
 *  Build dependencies
 */
assert networkBuild -> gnutls != null || opensslExtlib;
assert pixelutilsBuild -> avutilLibrary;
/*
 *  Program dependencies
 */
assert ffmpegProgram && reqMin "0.5" -> avcodecLibrary
                                     && avfilterLibrary
                                     && avformatLibrary
                                     && swresampleLibrary;
assert ffplayProgram && reqMin "0.5" -> avcodecLibrary
                                     && avformatLibrary
                                     && swscaleLibrary
                                     && swresampleLibrary
                                     && SDL != null;
assert ffprobeProgram && reqMin "0.6" -> avcodecLibrary && avformatLibrary;
assert ffserverProgram && reqMin "0.5" -> avformatLibrary;
/*
 *  Library dependencies
 */
assert avcodecLibrary && reqMin "0.6" -> avutilLibrary; # configure flag since 0.6
assert avdeviceLibrary && reqMin "0.6" -> avformatLibrary
                                       && avcodecLibrary
                                       && avutilLibrary; # configure flag since 0.6
assert avformatLibrary && reqMin "0.6" -> avcodecLibrary && avutilLibrary; # configure flag since 0.6
assert avresampleLibrary && reqMin "0.11" -> avutilLibrary;
assert postprocLibrary && reqMin "0.5" -> avutilLibrary;
assert swresampleLibrary && reqMin "0.9" -> soxr != null;
assert swscaleLibrary && reqMin "0.5" -> avutilLibrary;
/*
 *  External libraries
 */
#assert aacplusExtlib && reqMin "0.7" -> nonfreeLicensing;
#assert decklinkExtlib && reqMin "2.2" -> blackmagic-design-desktop-video != null
#                                       && !isCygwin && multithreadBuild # POSIX threads required
#                                       && nonfreeLicensing;
assert faacExtlib && reqMin "0.5" -> faac != null && nonfreeLicensing;
assert fdk-aacExtlib && reqMin "1.0" -> fdk_aac != null && nonfreeLicensing;
assert gnutls != null && reqMin "0.9" -> !opensslExtlib;
assert libxcb-shmExtlib && reqMin "2.5" -> libxcb != null;
assert libxcb-xfixesExtlib && reqMin "2.5" -> libxcb != null;
assert libxcb-shapeExtlib && reqMin "2.5" -> libxcb != null;
assert openglExtlib && reqMin "2.2" -> mesa != null;
assert opensslExtlib && reqMin "0.9" -> gnutls == null && openssl != null && nonfreeLicensing;
assert sambaExtlib && reqMin "2.3" -> samba != null && !isDarwin;
assert x11grabExtlib && reqMin "0.5" -> libX11 != null && libXv != null;

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "ffmpeg-${version}";
  inherit version;

  src = fetchurl {
    url = "https://www.ffmpeg.org/releases/${name}.tar.bz2";
    inherit sha256;
  };

  patchPhase = ''patchShebangs .'';

  configureFlags = [
    /*
     *  Licensing flags
     */
    (mkFlag gplLicensing "0.5" "gpl")
    (mkFlag version3Licensing "0.5" "version3")
    (mkFlag nonfreeLicensing "0.5" "nonfree")
    /*
     *  Build flags
     */
    # On some ARM platforms --enable-thumb
    "--enable-shared --disable-static"
    (mkFlag true "0.6" "pic")
    (if (stdenv.cc.cc.isClang or false) then "--cc=clang" else null)
    (mkFlag smallBuild "0.5" "small")
    (mkFlag runtime-cpudetectBuild "0.5" "runtime-cpudetect")
    (mkFlag grayBuild "0.5" "gray")
    (mkFlag swscale-alphaBuild "0.6" "swscale-alpha")
    (mkFlag incompatible-libav-abiBuild "2.0" "incompatible-libav-abi")
    (mkFlag hardcoded-tablesBuild "0.5" "hardcoded-tables")
    (mkFlag safe-bitstream-readerBuild "0.9" "safe-bitstream-reader")
    (mkFlag memalign-hackBuild "0.5" "memalign-hack")
    (if reqMin "0.5" then (
       if multithreadBuild then (
         if isCygwin then
           "--disable-pthreads --enable-w32threads"
         else # Use POSIX threads by default
           "--enable-pthreads --disable-w32threads")
       else
         "--disable-pthreads --disable-w32threads")
     else null)
    (if reqMin "0.9" then "--disable-os2threads" else null) # We don't support OS/2
    (mkFlag networkBuild "0.5" "network")
    (mkFlag pixelutilsBuild "2.4" "pixelutils")
    /*
     *  Program flags
     */
    (mkFlag ffmpegProgram "0.5" "ffmpeg")
    (mkFlag ffplayProgram "0.5" "ffplay")
    (mkFlag ffprobeProgram "0.6" "ffprobe")
    (mkFlag ffserverProgram "0.5" "ffserver")
    /*
     *  Library flags
     */
    (mkFlag avcodecLibrary "0.6" "avcodec")
    (mkFlag avdeviceLibrary "0.6" "avdevice")
    (mkFlag avfilterLibrary "0.5" "avfilter")
    (mkFlag avformatLibrary "0.6" "avformat")
    (mkFlag avresampleLibrary "1.0" "avresample")
    (mkFlag avutilLibrary "1.1" "avutil")
    (mkFlag (postprocLibrary && gplLicensing) "0.5" "postproc")
    (mkFlag swresampleLibrary "0.9" "swresample")
    (mkFlag swscaleLibrary "0.5" "swscale")
    /*
     *  Documentation flags
     */
    (mkFlag (htmlpagesDocumentation
          || manpagesDocumentation
          || podpagesDocumentation
          || txtpagesDocumentation) "0.6" "doc")
    (mkFlag htmlpagesDocumentation "1.0" "htmlpages")
    (mkFlag manpagesDocumentation "1.0" "manpages")
    (mkFlag podpagesDocumentation "1.0" "podpages")
    (mkFlag txtpagesDocumentation "1.0" "txtpages")
    /*
     *  External libraries
     */
    #(mkFlag aacplus      "0.7" "libaacplus")
    #(mkFlag avisynth     "0.5" "avisynth")
    (mkFlag (bzip2 != null) "0.5" "bzlib")
    (mkFlag (celt != null) "0.8" "libcelt")
    #crystalhd
    #(mkFlag decklinkExtlib "2.2" "decklink")
    (mkFlag faacExtlib "0.5" "libfaac")
    (depFlag faad2Extlib "0.5" "0.6" "libfaad")
    (mkFlag (fdk-aacExtlib && gplLicensing) "1.0" "libfdk-aac")
    #(mkFlag (flite != null) "1.0" "libflite")
    (if reqMin "1.0" then # Force disable until a solution is found
      "--disable-libflite"
     else null)
    (mkFlag (fontconfig != null) "1.0" "fontconfig")
    (mkFlag (freetype != null) "0.7" "libfreetype")
    (mkFlag (disDarwinFix (frei0r != null && gplLicensing)) "0.7" "frei0r")
    (mkFlag (fribidi != null) "2.3" "libfribidi")
    #(mkFlag (disDarwinFix (game-music-emu != null)) "2.2" "libgme")
    (mkFlag (gnutls != null) "0.9" "gnutls")
    #(verFix (mkFlag (disDarwinFix (gsm != null)) "0.5" "libgsm") "0.5" "--disable-libgsm")
    #(mkFlag (ilbc != null) "1.0" "libilbc")
    (mkFlag (ladspaH !=null) "2.1" "ladspa")
    (mkFlag (lame != null) "0.5" "libmp3lame")
    (mkFlag (libass != null) "0.9" "libass")
    #(mkFlag (libavc1394 != null) null null)
    (mkFlag (libbluray != null) "1.0" "libbluray")
    (mkFlag (libbs2b != null) "2.3" "libbs2b")
    #(mkFlag (libcaca != null) "1.0" "libcaca")
    #(mkFlag (cdio-paranoia != null && gplLicensing) "0.9" "libcdio")
    (mkFlag (if !isLinux then false else libdc1394 != null && libraw1394 != null && isLinux) "0.5" "libdc1394")
    (mkFlag (libiconv != null) "1.2" "iconv")
    #(mkFlag (if !isLinux then false else libiec61883 != null && libavc1394 != null && libraw1394 != null) "1.0" "libiec61883")
    #(mkFlag (libmfx != null) "2.6" "libmfx")
    (mkFlag (disDarwinFix (libmodplug != null)) "0.9" "libmodplug")
    #(mkFlag (libnut != null) "0.5" "libnut")
    (mkFlag (libopus != null) "1.0" "libopus")
    (mkFlag (disDarwinFix (libssh != null)) "2.1" "libssh")
    (mkFlag (libtheora != null) "0.5" "libtheora")
    (mkFlag (if isDarwin then false else libva != null) "0.6" "vaapi")
    (mkFlag (libvdpau != null) "0.5" "vdpau")
    (mkFlag (libvorbis != null) "0.5" "libvorbis")
    (mkFlag (disDarwinFix (libvpx != null)) "0.6" "libvpx")
    (mkFlag (libwebp != null) "2.2" "libwebp")
    (mkFlag (libX11 != null && libXv != null) "2.3" "xlib")
    (mkFlag (libxcb != null) "2.5" "libxcb")
    (mkFlag libxcb-shmExtlib "2.5" "libxcb-shm")
    (mkFlag libxcb-xfixesExtlib "2.5" "libxcb-xfixes")
    (mkFlag libxcb-shapeExtlib "2.5" "libxcb-shape")
    (mkFlag (lzma != null) "2.4" "lzma")
    #(mkFlag nvenc        "2.6" "nvenc")
    #(mkFlag (disDarwinFix (openal != null)) "0.9" "openal")
    #(mkFlag opencl       "2.2" "opencl")
    #(mkFlag (opencore-amr != null && version3Licensing) "0.5" "libopencore-amrnb")
    #(mkFlag (opencv != null) "1.1" "libopencv") # Actual min. version 0.7
    (mkFlag openglExtlib "2.2" "opengl")
    #(mkFlag (openh264 != null) "2.6" "openh264")
    (mkFlag (disDarwinFix (openjpeg_1 != null)) "0.5" "libopenjpeg")
    (mkFlag (opensslExtlib && gplLicensing) "0.9" "openssl")
    (mkFlag (disDarwinFix (pulseaudio != null)) "0.9" "libpulse")
    #(mkFlag quvi         "2.0" "libquvi")
    (mkFlag (disDarwinFix (rtmpdump != null)) "0.6" "librtmp")
    #(mkFlag (schroedinger != null) "0.5" "libschroedinger")
    #(mkFlag (shine != null) "2.0" "libshine")
    (mkFlag (disDarwinFix (sambaExtlib && gplLicensing && version3Licensing)) "2.3" "libsmbclient")
    (mkFlag (SDL != null) "2.5" "sdl") # Only configurable since 2.5, auto detected before then
    (mkFlag (soxr != null) "1.2" "libsoxr")
    (mkFlag (speex != null) "0.5" "libspeex")
    #(mkFlag (twolame != null) "1.0" "libtwolame")
    #(mkFlag (utvideo != null && gplLicensing) "0.9" "libutvideo")
    #(mkFlag (if !isLinux then false else v4l_utils != null && isLinux) "0.9" "libv4l2")
    (mkFlag (disDarwinFix (vid-stab != null && gplLicensing)) "2.2" "libvidstab") # Actual min. version 2.0
    #(mkFlag (vo-aacenc != null && version3Licensing) "0.6" "libvo-aacenc")
    #(mkFlag (vo-amrwbenc != null && version3Licensing) "0.7" "libvo-amrwbenc")
    (mkFlag (disDarwinFix (wavpack != null)) "2.0" "libwavpack")
    (mkFlag (x11grabExtlib && gplLicensing) "0.5" "x11grab")
    (mkFlag (x264 != null && gplLicensing) "0.5" "libx264")
    (mkFlag (disDarwinFix (x265 != null && gplLicensing)) "2.2" "libx265")
    #(mkFlag (disDarwinFix (xavs != null && gplLicensing)) "0.7" "libxavs")
    (mkFlag (xvidcore != null && gplLicensing) "0.5" "libxvid")
    #(mkFlag (zeromq4 != null) "2.0" "libzmq")
    (mkFlag (zlib != null) "0.5" "zlib")
    #(mkFlag (zvbi != null && gplLicensing) "2.1" "libzvbi")
    /*
     * Developer flags
     */
    (mkFlag debugDeveloper "0.5" "debug")
    (mkFlag optimizationsDeveloper "0.5" "optimizations")
    (mkFlag extra-warningsDeveloper "0.5" "extra-warnings")
    (mkFlag strippingDeveloper "0.5" "stripping")
    
    # Disable mmx support for 0.6.90
    (verFix null "0.6.90" "--disable-mmx")
  ];

  nativeBuildInputs = [ perl pkgconfig texinfo yasm ];

  buildInputs = [
    bzip2 celt fontconfig freetype fribidi gnutls ladspaH lame libass libbluray
    libbs2b /* libcaca */ libdc1394 libogg libopus libtheora libvdpau libvorbis
    libwebp libX11 libxcb libXext libXfixes libXv lzma SDL soxr speex x264
    xvidcore /* zeromq4 */ zlib
  ] ++ optional (disDarwinFix sambaExtlib) samba
    ++ optional openglExtlib mesa
    ++ optionals x11grabExtlib [ libXext libXfixes ]
    ++ optionals nonfreeLicensing [ faac faad2 fdk_aac openssl ]
    ++ optionals (!isDarwin) [
      frei0r /* game-music-emu gsm jack2 */ libmodplug libssh libvpx /* openal */
      openjpeg_1 pulseaudio rtmpdump vid-stab wavpack x265 /* xavs */
  ] ++ optional (!isDarwin && !isCygwin) libva
    ++ optionals isLinux [ alsaLib libraw1394 /* v4l_utils */ ];

  # Build qt-faststart executable
  buildPhase = optional (qt-faststartProgram && (reqMin "0.9")) ''make tools/qt-faststart'';
  postInstall = optional (qt-faststartProgram && (reqMin "0.9")) ''cp -a tools/qt-faststart $out/bin/'';

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

  /* TODO: In the future more FFmpeg optionals should be added so that packages that
     depend on FFmpeg can check to make sure a required feature is enabled.  Since
     features are version dependent, versioning needs to be handled as well */
  passthru = {
    vdpauSupport = libvdpau != null;
  };

  meta = {
    description = "A complete, cross-platform solution to record, convert and stream audio and video";
    homepage = http://www.ffmpeg.org/;
    longDescription = ''
      FFmpeg is the leading multimedia framework, able to decode, encode, transcode, 
      mux, demux, stream, filter and play pretty much anything that humans and machines 
      have created. It supports the most obscure ancient formats up to the cutting edge. 
      No matter if they were designed by some standards committee, the community or 
      a corporation. 
    '';
    license = (
      if nonfreeLicensing then
        licenses.unfreeRedistributable
      else if version3Licensing then
        licenses.gpl3
      else if gplLicensing then
        licenses.gpl2Plus
      else
        licenses.lgpl21Plus
    );
    platforms = platforms.all;
    maintainers = with maintainers; [ codyopel fuuzetsu ];
    inherit branch;
  };
}
