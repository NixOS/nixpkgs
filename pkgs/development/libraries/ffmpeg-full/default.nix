{ lib, stdenv, buildPackages, ffmpeg, addOpenGLRunpath, pkg-config, perl, texinfo, yasm
/*
 *  Licensing options (yes some are listed twice, filters and such are not listed)
 */
, gplLicensing ? true # GPL: fdkaac,openssl,frei0r,cdio,samba,utvideo,vidstab,x265,x265,xavs,avid,zvbi,x11grab
, version3Licensing ? true # (L)GPL3: libvmaf,opencore-amrnb,opencore-amrwb,samba,vo-aacenc,vo-amrwbenc
, nonfreeLicensing ? false # NONFREE: openssl,fdkaac,blackmagic-design-desktop-video
/*
 *  Build options
 */
, smallBuild ? false # Optimize for size instead of speed
, runtimeCpuDetectBuild ? true # Detect CPU capabilities at runtime (disable to compile natively)
, grayBuild ? true # Full grayscale support
, swscaleAlphaBuild ? true # Alpha channel support in swscale
, hardcodedTablesBuild ? true # Hardcode decode tables instead of runtime generation
, safeBitstreamReaderBuild ? true # Buffer boundary checking in bitreaders
, multithreadBuild ? true # Multithreading via pthreads/win32 threads
, networkBuild ? true # Network support
, pixelutilsBuild ? true # Pixel utils in libavutil
, enableLto ? false # build with link-time optimization
/*
 *  Program options
 */
, ffmpegProgram ? true # Build ffmpeg executable
, ffplayProgram ? true # Build ffplay executable
, ffprobeProgram ? true # Build ffprobe executable
, qtFaststartProgram ? true # Build qt-faststart executable
/*
 *  Library options
 */
, avcodecLibrary ? true # Build avcodec library
, avdeviceLibrary ? true # Build avdevice library
, avfilterLibrary ? true # Build avfilter library
, avformatLibrary ? true # Build avformat library
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
, alsa-lib ? null # Alsa in/output support
#, avisynth ? null # Support for reading AviSynth scripts
, bzip2 ? null
, celt ? null # CELT decoder
#, crystalhd ? null # Broadcom CrystalHD hardware acceleration
, dav1d ? null # AV1 decoder (focused on speed and correctness)
#, decklinkExtlib ? false, blackmagic-design-desktop-video ? null # Blackmagic Design DeckLink I/O support
, fdkaacExtlib ? false, fdk_aac ? null # Fraunhofer FDK AAC de/encoder
#, flite ? null # Flite (voice synthesis) support
, fontconfig ? null # Needed for drawtext filter
, freetype ? null # Needed for drawtext filter
, frei0r ? null # frei0r video filtering
, fribidi ? null # Needed for drawtext filter
, game-music-emu ? null # Game Music Emulator
, gnutls ? null
, gsm ? null # GSM de/encoder
#, ilbc ? null # iLBC de/encoder
, libjack2 ? null # Jack audio (only version 2 is supported in this build)
, ladspaH ? null # LADSPA audio filtering
, lame ? null # LAME MP3 encoder
, libass ? null # (Advanced) SubStation Alpha subtitle rendering
, libaom ? null # AV1 encoder
, libbluray ? null # BluRay reading
, libbs2b ? null # bs2b DSP library
, libcaca ? null # Textual display (ASCII art)
#, libcdio-paranoia ? null # Audio CD grabbing
, libdc1394 ? null, libraw1394 ? null # IIDC-1394 grabbing (ieee 1394)
, libdrm ? null # libdrm support
, libiconv ? null
#, libiec61883 ? null, libavc1394 ? null # iec61883 (also uses libraw1394)
, libmfx ? null # Hardware acceleration vis libmfx
, libmodplug ? null # ModPlug support
, libmysofa ? null # HRTF support via SOFAlizer
#, libnut ? null # NUT (de)muxer, native (de)muser exists
, libogg ? null # Ogg container used by vorbis & theora
, libopus ? null # Opus de/encoder
, librsvg ? null # SVG protocol
, libssh ? null # SFTP protocol
, libtheora ? null # Theora encoder
, libv4l ? null # Video 4 Linux support
, libva ? null # Vaapi hardware acceleration
, libvdpau ? null # Vdpau hardware acceleration
, libvmaf ? null # Netflix's VMAF (Video Multi-Method Assessment Fusion)
, libvorbis ? null # Vorbis de/encoding, native encoder exists
, libvpx ? null # VP8 & VP9 de/encoding
, libwebp ? null # WebP encoder
, libX11 ? null # Xlib support
, libxcb ? null # X11 grabbing using XCB
, libxcbshmExtlib ? true # X11 grabbing shm communication
, libxcbxfixesExtlib ? true # X11 grabbing mouse rendering
, libxcbshapeExtlib ? true # X11 grabbing shape rendering
, libXv ? null # Xlib support
, libXext ? null # Xlib support
, libxml2 ? null # libxml2 support, for IMF and DASH demuxers
, xz ? null # xz-utils
, nvenc ? !stdenv.isDarwin && !stdenv.isAarch64, nv-codec-headers ? null # NVIDIA NVENC support
, openal ? null # OpenAL 1.1 capture support
#, opencl ? null # OpenCL code
, opencore-amr ? null # AMR-NB de/encoder & AMR-WB decoder
#, opencv ? null # Video filtering
, openglExtlib ? false, libGL ? null, libGLU ? null # OpenGL rendering
, openh264 ? null # H.264/AVC encoder
, openjpeg ? null # JPEG 2000 de/encoder
, opensslExtlib ? false, openssl ? null
, libpulseaudio ? null # Pulseaudio input support
, rav1e ? null # AV1 encoder (focused on speed and safety)
, svt-av1 ? null # AV1 encoder/decoder (focused on speed and correctness)
, rtmpdump ? null # RTMP[E] support
#, libquvi ? null # Quvi input support
, samba ? null # Samba protocol
#, schroedinger ? null # Dirac de/encoder
, SDL2 ? null
#, shine ? null # Fixed-point MP3 encoder
, soxr ? null # Resampling via soxr
, speex ? null # Speex de/encoder
, srt ? null # Secure Reliable Transport (SRT) protocol
#, twolame ? null # MP2 encoder
#, utvideo ? null # Ut Video de/encoder
, vid-stab ? null # Video stabilization
#, vo-aacenc ? null # AAC encoder
, vo-amrwbenc ? null # AMR-WB encoder
, x264 ? null # H.264/AVC encoder
, x265 ? null # H.265/HEVC encoder
, xavs ? null # AVS encoder
, xvidcore ? null # Xvid encoder, native encoder exists
, zeromq4 ? null # Message passing
, zimg ? null
, zlib ? null
, vulkan-loader ? null
, glslang ? null
#, zvbi ? null # Teletext support
/*
 *  Developer options
 */
, debugDeveloper ? false
, optimizationsDeveloper ? true
, extraWarningsDeveloper ? false
, strippingDeveloper ? false
/*
 *  Darwin frameworks
 */
, Cocoa, CoreAudio, CoreServices, AVFoundation, MediaToolbox
, VideoDecodeAcceleration
}:

/* Maintainer notes:
 *
 * Version bumps:
 * It should always be safe to bump patch releases (e.g. 2.1.x, x being a patch release)
 * If adding a new branch, note any configure flags that were added, changed, or deprecated/removed
 *   and make the necessary changes.
 *
 * Packages with errors:
 *   flite ilbc schroedinger
 *   opencv - circular dependency issue
 *
 * Not packaged:
 *   aacplus avisynth cdio-paranoia crystalhd libavc1394 libiec61883
 *   libnut libquvi nvenc opencl oss shine twolame
 *   utvideo vo-aacenc vo-amrwbenc xvmc zvbi blackmagic-design-desktop-video
 *
 * Need fixes to support Darwin:
 *   gsm libjack2 libmodplug libmfx(intel-media-sdk) nvenc pulseaudio samba
 *   vid-stab
 *
 * Need fixes to support AArch64:
 *   libmfx(intel-media-sdk) nvenc
 *
 * Not supported:
 *   stagefright-h264(android only)
 *
 * Known issues:
 * flite: configure fails to find library
 *   Tried modifying ffmpeg's configure script and flite to use pkg-config
 * Cross-compiling will disable features not present on host OS
 *   (e.g. dxva2 support [DirectX] will not be enabled unless natively compiled on Cygwin)
 *
 */

let
  inherit (stdenv) isCygwin isDarwin isFreeBSD isLinux isAarch64;
  inherit (lib) optional optionals optionalString enableFeature;
in

/*
 *  Licensing dependencies
 */
assert version3Licensing -> gplLicensing;
assert nonfreeLicensing -> gplLicensing && version3Licensing;
/*
 *  Build dependencies
 */
assert networkBuild -> gnutls != null || opensslExtlib;
assert pixelutilsBuild -> avutilLibrary;
/*
 *  Platform dependencies
 */
assert isDarwin -> !nvenc;
/*
 *  Program dependencies
 */
assert ffmpegProgram -> avcodecLibrary
                     && avfilterLibrary
                     && avformatLibrary
                     && swresampleLibrary;
assert ffplayProgram -> avcodecLibrary
                     && avformatLibrary
                     && swscaleLibrary
                     && swresampleLibrary
                     && SDL2 != null;
assert ffprobeProgram -> avcodecLibrary && avformatLibrary;
/*
 *  Library dependencies
 */
assert avcodecLibrary -> avutilLibrary; # configure flag since 0.6
assert avdeviceLibrary -> avformatLibrary
                       && avcodecLibrary
                       && avutilLibrary; # configure flag since 0.6
assert avformatLibrary -> avcodecLibrary && avutilLibrary; # configure flag since 0.6
assert postprocLibrary -> avutilLibrary;
assert swresampleLibrary -> soxr != null;
assert swscaleLibrary -> avutilLibrary;
/*
 *  External libraries
 */
#assert decklinkExtlib -> blackmagic-design-desktop-video != null
#                                       && !isCygwin && multithreadBuild # POSIX threads required
#                                       && nonfreeLicensing;
assert fdkaacExtlib -> fdk_aac != null && nonfreeLicensing;
assert gnutls != null -> !opensslExtlib;
assert libxcbshmExtlib -> libxcb != null;
assert libxcbxfixesExtlib -> libxcb != null;
assert libxcbshapeExtlib -> libxcb != null;
assert openglExtlib -> libGL != null && libGLU != null;
assert opensslExtlib -> gnutls == null && openssl != null && nonfreeLicensing;

stdenv.mkDerivation rec {
  pname = "ffmpeg-full";
  inherit (ffmpeg) src version patches;

  prePatch = ''
    patchShebangs .
  '' + lib.optionalString stdenv.isDarwin ''
    sed -i 's/#ifndef __MAC_10_11/#if 1/' ./libavcodec/audiotoolboxdec.c
  '' + lib.optionalString (frei0r != null) ''
    substituteInPlace libavfilter/vf_frei0r.c \
      --replace /usr/local/lib/frei0r-1 ${frei0r}/lib/frei0r-1
    substituteInPlace doc/filters.texi \
      --replace /usr/local/lib/frei0r-1 ${frei0r}/lib/frei0r-1
  '';

  configurePlatforms = [];
  configureFlags = [
    "--target_os=${if stdenv.hostPlatform.isMinGW then "mingw64" else stdenv.hostPlatform.parsed.kernel.name}" #mingw32 and mingw64 doesn't have a difference here, it is internally rewritten as mingw32
    "--arch=${stdenv.hostPlatform.parsed.cpu.name}"
    /*
     *  Licensing flags
     */
    (enableFeature gplLicensing "gpl")
    (enableFeature version3Licensing "version3")
    (enableFeature nonfreeLicensing "nonfree")
    /*
     *  Build flags
     */
    # On some ARM platforms --enable-thumb
    "--enable-shared"
    (enableFeature true "pic")
    (enableFeature smallBuild "small")
    (enableFeature runtimeCpuDetectBuild "runtime-cpudetect")
    (enableFeature enableLto "lto")
    (enableFeature grayBuild "gray")
    (enableFeature swscaleAlphaBuild "swscale-alpha")
    (enableFeature hardcodedTablesBuild "hardcoded-tables")
    (enableFeature safeBitstreamReaderBuild "safe-bitstream-reader")
    (if multithreadBuild then (
       if stdenv.hostPlatform.isWindows then
         "--disable-pthreads --enable-w32threads"
       else # Use POSIX threads by default
         "--enable-pthreads --disable-w32threads")
     else
       "--disable-pthreads --disable-w32threads")
    "--disable-os2threads" # We don't support OS/2
    (enableFeature networkBuild "network")
    (enableFeature pixelutilsBuild "pixelutils")
    /*
     *  Program flags
     */
    (enableFeature ffmpegProgram "ffmpeg")
    (enableFeature ffplayProgram "ffplay")
    (enableFeature ffprobeProgram "ffprobe")
    /*
     *  Library flags
     */
    (enableFeature avcodecLibrary "avcodec")
    (enableFeature avdeviceLibrary "avdevice")
    (enableFeature avfilterLibrary "avfilter")
    (enableFeature avformatLibrary "avformat")
    (enableFeature avutilLibrary "avutil")
    (enableFeature (postprocLibrary && gplLicensing) "postproc")
    (enableFeature swresampleLibrary "swresample")
    (enableFeature swscaleLibrary "swscale")
    /*
     *  Documentation flags
     */
    (enableFeature (htmlpagesDocumentation
          || manpagesDocumentation
          || podpagesDocumentation
          || txtpagesDocumentation) "doc")
    (enableFeature htmlpagesDocumentation "htmlpages")
    (enableFeature manpagesDocumentation "manpages")
    (enableFeature podpagesDocumentation "podpages")
    (enableFeature txtpagesDocumentation "txtpages")
    /*
     *  External libraries
     */
    #(enableFeature avisynth "avisynth")
    (enableFeature (bzip2 != null) "bzlib")
    (enableFeature (celt != null) "libcelt")
    #(enableFeature crystalhd "crystalhd")
    (enableFeature (dav1d != null) "libdav1d")
    #(enableFeature decklinkExtlib "decklink")
    (enableFeature (fdkaacExtlib && gplLicensing) "libfdk-aac")
    #(enableFeature (flite != null) "libflite")
    "--disable-libflite" # Force disable until a solution is found
    (enableFeature (fontconfig != null) "fontconfig")
    (enableFeature (freetype != null) "libfreetype")
    (enableFeature (frei0r != null && gplLicensing) "frei0r")
    (enableFeature (fribidi != null) "libfribidi")
    (enableFeature (game-music-emu != null) "libgme")
    (enableFeature (gnutls != null) "gnutls")
    (enableFeature (gsm != null) "libgsm")
    #(enableFeature (ilbc != null) "libilbc")
    (enableFeature (ladspaH !=null) "ladspa")
    (enableFeature (lame != null) "libmp3lame")
    (enableFeature (libaom != null) "libaom")
    (enableFeature (libass != null) "libass")
    #(enableFeature (libavc1394 != null) null null)
    (enableFeature (libbluray != null) "libbluray")
    (enableFeature (libbs2b != null) "libbs2b")
    #(enableFeature (libcaca != null) "libcaca")
    #(enableFeature (cdio-paranoia != null && gplLicensing) "libcdio")
    (enableFeature (if isLinux then libdc1394 != null && libraw1394 != null else false) "libdc1394")
    (enableFeature ((isLinux || isFreeBSD) && libdrm != null) "libdrm")
    (enableFeature (libiconv != null) "iconv")
    (enableFeature (libjack2 != null) "libjack")
    #(enableFeature (if isLinux then libiec61883 != null && libavc1394 != null && libraw1394 != null else false) "libiec61883")
    (enableFeature (if isLinux && !isAarch64 then libmfx != null else false) "libmfx")
    (enableFeature (libmodplug != null) "libmodplug")
    (enableFeature (libmysofa != null) "libmysofa")
    #(enableFeature (libnut != null) "libnut")
    (enableFeature (libopus != null) "libopus")
    (enableFeature (librsvg != null) "librsvg")
    (enableFeature (srt != null) "libsrt")
    (enableFeature (libssh != null) "libssh")
    (enableFeature (libtheora != null) "libtheora")
    (enableFeature (if isLinux then libv4l != null else false) "libv4l2")
    (enableFeature ((isLinux || isFreeBSD) && libva != null) "vaapi")
    (enableFeature (libvdpau != null) "vdpau")
    (enableFeature (libvorbis != null) "libvorbis")
    (enableFeature (!isAarch64 && libvmaf != null && version3Licensing) "libvmaf")
    (enableFeature (libvpx != null) "libvpx")
    (enableFeature (libwebp != null) "libwebp")
    (enableFeature (libX11 != null && libXv != null && libXext != null) "xlib")
    (enableFeature (libxcb != null) "libxcb")
    (enableFeature libxcbshmExtlib "libxcb-shm")
    (enableFeature libxcbxfixesExtlib "libxcb-xfixes")
    (enableFeature libxcbshapeExtlib "libxcb-shape")
    (enableFeature (libxml2 != null) "libxml2")
    (enableFeature (xz != null) "lzma")
    (enableFeature nvenc "nvenc")
    (enableFeature (openal != null) "openal")
    #(enableFeature opencl "opencl")
    (enableFeature (opencore-amr != null && version3Licensing) "libopencore-amrnb")
    #(enableFeature (opencv != null) "libopencv")
    (enableFeature openglExtlib "opengl")
    (enableFeature (openh264 != null) "libopenh264")
    (enableFeature (openjpeg != null) "libopenjpeg")
    (enableFeature (opensslExtlib && gplLicensing) "openssl")
    (enableFeature (libpulseaudio != null) "libpulse")
    #(enableFeature quvi "libquvi")
    (enableFeature (rav1e != null) "librav1e")
    (enableFeature (svt-av1 != null) "libsvtav1")
    (enableFeature (rtmpdump != null) "librtmp")
    #(enableFeature (schroedinger != null) "libschroedinger")
    (enableFeature (SDL2 != null) "sdl2")
    (enableFeature (soxr != null) "libsoxr")
    (enableFeature (speex != null) "libspeex")
    #(enableFeature (twolame != null) "libtwolame")
    #(enableFeature (utvideo != null && gplLicensing) "libutvideo")
    (enableFeature (vid-stab != null && gplLicensing) "libvidstab") # Actual min. version 2.0
    #(enableFeature (vo-aacenc != null && version3Licensing) "libvo-aacenc")
    (enableFeature (vo-amrwbenc != null && version3Licensing) "libvo-amrwbenc")
    (enableFeature (x264 != null && gplLicensing) "libx264")
    (enableFeature (x265 != null && gplLicensing) "libx265")
    (enableFeature (xavs != null && gplLicensing) "libxavs")
    (enableFeature (xvidcore != null && gplLicensing) "libxvid")
    (enableFeature (zeromq4 != null) "libzmq")
    (enableFeature (zimg != null) "libzimg")
    (enableFeature (zlib != null) "zlib")
    (enableFeature (isLinux && vulkan-loader != null) "vulkan")
    (enableFeature (isLinux && vulkan-loader != null && glslang != null) "libglslang")
    (enableFeature (samba != null && gplLicensing && version3Licensing) "libsmbclient")
    #(enableFeature (zvbi != null && gplLicensing) "libzvbi")
    /*
     * Developer flags
     */
    (enableFeature debugDeveloper "debug")
    (enableFeature optimizationsDeveloper "optimizations")
    (enableFeature extraWarningsDeveloper "extra-warnings")
    (enableFeature strippingDeveloper "stripping")
  ] ++ optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "--cross-prefix=${stdenv.cc.targetPrefix}"
    "--enable-cross-compile"
    "--host-cc=${buildPackages.stdenv.cc}/bin/cc"
  ] ++ optionals stdenv.cc.isClang [
    "--cc=clang"
    "--cxx=clang++"
  ];

  nativeBuildInputs = [ addOpenGLRunpath perl pkg-config texinfo yasm ];

  buildInputs = [
    bzip2 celt dav1d fontconfig freetype frei0r fribidi game-music-emu gnutls gsm
    libjack2 ladspaH lame libaom libass libbluray libbs2b libcaca libdc1394 libmodplug libmysofa
    libogg libopus librsvg libssh libtheora libvdpau libvorbis libvpx libwebp libX11
    libxcb libXv libXext libxml2 xz openal openjpeg libpulseaudio rav1e svt-av1 rtmpdump opencore-amr
    samba SDL2 soxr speex srt vid-stab vo-amrwbenc x264 x265 xavs xvidcore
    zeromq4 zimg zlib openh264
  ] ++ optionals openglExtlib [ libGL libGLU ]
    ++ optionals nonfreeLicensing [ fdk_aac openssl ]
    ++ optional ((isLinux || isFreeBSD) && libva != null) libva
    ++ optional ((isLinux || isFreeBSD) && libdrm != null) libdrm
    ++ optional (!isAarch64 && libvmaf != null && version3Licensing) libvmaf
    ++ optionals isLinux [ alsa-lib libraw1394 libv4l vulkan-loader glslang ]
    ++ optional (isLinux && !isAarch64 && libmfx != null) libmfx
    ++ optional nvenc nv-codec-headers
    ++ optionals stdenv.isDarwin [ Cocoa CoreServices CoreAudio AVFoundation
                                   MediaToolbox VideoDecodeAcceleration
                                   libiconv ];

  buildFlags = [ "all" ]
    ++ optional qtFaststartProgram "tools/qt-faststart"; # Build qt-faststart executable

  doCheck = true;
  checkPhase = let
    ldLibraryPathEnv = if stdenv.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
  in ''
    ${ldLibraryPathEnv}="libavcodec:libavdevice:libavfilter:libavformat:libavutil:libpostproc:libswresample:libswscale:''${${ldLibraryPathEnv}}" \
      make check -j$NIX_BUILD_CORES
  '';

  # Hacky framework patching technique borrowed from the phantomjs2 package
  postInstall = optionalString qtFaststartProgram ''
    cp -a tools/qt-faststart $out/bin/
  '';

  postFixup = optionalString stdenv.isLinux ''
    # Set RUNPATH so that libnvcuvid and libcuda in /run/opengl-driver(-32)/lib can be found.
    # See the explanation in addOpenGLRunpath.
    addOpenGLRunpath $out/lib/libavcodec.so
    addOpenGLRunpath $out/lib/libavutil.so
  '';

  enableParallelBuilding = true;

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
    maintainers = with maintainers; [ codyopel ];
  };
}
