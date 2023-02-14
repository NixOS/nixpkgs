{ version, sha256, extraPatches ? [], knownVulnerabilities ? [] }:

{ lib, stdenv, buildPackages, removeReferencesTo, addOpenGLRunpath, pkg-config, perl, texinfo, yasm

, ffmpegVariant ? "small" # Decides which dependencies are enabled by default

  # Build with headless deps; excludes dependencies that are only necessary for
  # GUI applications. To be used for purposes that don't generally need such
  # components and i.e. only depend on libav
, withHeadlessDeps ? ffmpegVariant == "headless" || withSmallDeps

  # Dependencies a user might customarily expect from a regular ffmpeg build.
  # /All/ packages that depend on ffmpeg and some of its feaures should depend
  # on the small variant. Small means the minimal set of features that satisfies
  # all dependants in Nixpkgs
, withSmallDeps ? ffmpegVariant == "small" || withFullDeps

  # Everything enabled; only guarded behind platform exclusivity or brokeness.
  # If you need to depend on ffmpeg-full because ffmpeg is missing some feature
  # your package needs, you should enable that feature in regular ffmpeg
  # instead.
, withFullDeps ? ffmpegVariant == "full"

, fetchgit
, fetchpatch

  # Feature flags
, withAlsa ? withHeadlessDeps && stdenv.isLinux # Alsa in/output supporT
, withAom ? withFullDeps # AV1 reference encoder
, withAss ? withHeadlessDeps && stdenv.hostPlatform == stdenv.buildPlatform # (Advanced) SubStation Alpha subtitle rendering
, withBluray ? withFullDeps # BluRay reading
, withBs2b ? withFullDeps # bs2b DSP library
, withBzlib ? withHeadlessDeps
, withCaca ? withFullDeps # Textual display (ASCII art)
, withCelt ? withFullDeps # CELT decoder
, withCrystalhd ? withFullDeps
, withCuda ? withFullDeps && (with stdenv; (!isDarwin && !isAarch64))
, withCudaLLVM ? withFullDeps
, withDav1d ? withHeadlessDeps # AV1 decoder (focused on speed and correctness)
, withDc1394 ? withFullDeps && !stdenv.isDarwin # IIDC-1394 grabbing (ieee 1394)
, withDrm ? withHeadlessDeps && (with stdenv; isLinux || isFreeBSD) # libdrm support
, withFdkAac ? withFullDeps && withUnfree # Fraunhofer FDK AAC de/encoder
, withFontconfig ? withHeadlessDeps # Needed for drawtext filter
, withFreetype ? withHeadlessDeps # Needed for drawtext filter
, withFrei0r ? withFullDeps # frei0r video filtering
, withFribidi ? withFullDeps # Needed for drawtext filter
, withGlslang ? withFullDeps && !stdenv.isDarwin
, withGme ? withFullDeps # Game Music Emulator
, withGnutls ? withHeadlessDeps
, withGsm ? withFullDeps # GSM de/encoder
, withIconv ? withHeadlessDeps
, withIlbc ? withFullDeps
, withJack ? withFullDeps && !stdenv.isDarwin # Jack audio
, withLadspa ? withFullDeps # LADSPA audio filtering
, withLzma ? withHeadlessDeps # xz-utils
, withMfx ? withFullDeps && (with stdenv.targetPlatform; isLinux && !isAarch) # Hardware acceleration via intel-media-sdk/libmfx
, withModplug ? withFullDeps && !stdenv.isDarwin # ModPlug support
, withMp3lame ? withHeadlessDeps # LAME MP3 encoder
, withMysofa ? withFullDeps # HRTF support via SOFAlizer
, withNvdec ? withHeadlessDeps && !stdenv.isDarwin && stdenv.hostPlatform == stdenv.buildPlatform
, withNvenc ? withHeadlessDeps && !stdenv.isDarwin && stdenv.hostPlatform == stdenv.buildPlatform
, withOgg ? withHeadlessDeps # Ogg container used by vorbis & theora
, withOpenal ? withFullDeps # OpenAL 1.1 capture support
, withOpencl ? withFullDeps
, withOpencoreAmrnb ? withFullDeps # AMR-NB de/encoder & AMR-WB decoder
, withOpengl ? false # OpenGL rendering
, withOpenh264 ? withFullDeps # H.264/AVC encoder
, withOpenjpeg ? withFullDeps # JPEG 2000 de/encoder
, withOpenmpt ? withFullDeps # Tracked music files decoder
, withOpus ? withHeadlessDeps # Opus de/encoder
, withPulse ? withSmallDeps && !stdenv.isDarwin # Pulseaudio input support
, withRav1e ? withFullDeps # AV1 encoder (focused on speed and safety)
, withRtmp ? false # RTMP[E] support
, withSamba ? withFullDeps && !stdenv.isDarwin # Samba protocol
, withSdl2 ? withSmallDeps
, withSoxr ? withHeadlessDeps # Resampling via soxr
, withSpeex ? withHeadlessDeps # Speex de/encoder
, withSrt ? withHeadlessDeps # Secure Reliable Transport (SRT) protocol
, withSsh ? withHeadlessDeps # SFTP protocol
, withSvg ? withFullDeps # SVG protocol
, withSvtav1 ? withFullDeps && !stdenv.isAarch64 # AV1 encoder/decoder (focused on speed and correctness)
, withTheora ? withHeadlessDeps # Theora encoder
, withV4l2 ? withFullDeps && !stdenv.isDarwin # Video 4 Linux support
, withV4l2M2m ? withV4l2
, withVaapi ? withHeadlessDeps && (with stdenv; isLinux || isFreeBSD) # Vaapi hardware acceleration
, withVdpau ? withSmallDeps # Vdpau hardware acceleration
, withVidStab ? withFullDeps # Video stabilization
, withVmaf ? withFullDeps && withGPLv3 && !stdenv.isAarch64 # Netflix's VMAF (Video Multi-Method Assessment Fusion)
, withVoAmrwbenc ? withFullDeps # AMR-WB encoder
, withVorbis ? withHeadlessDeps # Vorbis de/encoding, native encoder exists
, withVpx ? withHeadlessDeps && stdenv.buildPlatform == stdenv.hostPlatform # VP8 & VP9 de/encoding
, withVulkan ? withFullDeps && !stdenv.isDarwin
, withWebp ? withFullDeps # WebP encoder
, withX264 ? withHeadlessDeps # H.264/AVC encoder
, withX265 ? withHeadlessDeps # H.265/HEVC encoder
, withXavs ? withFullDeps # AVS encoder
, withXcb ? withXcbShm || withXcbxfixes || withXcbShape # X11 grabbing using XCB
, withXcbShape ? withFullDeps # X11 grabbing shape rendering
, withXcbShm ? withFullDeps # X11 grabbing shm communication
, withXcbxfixes ? withFullDeps # X11 grabbing mouse rendering
, withXlib ? withFullDeps # Xlib support
, withXml2 ? withFullDeps # libxml2 support, for IMF and DASH demuxers
, withXvid ? withHeadlessDeps # Xvid encoder, native encoder exists
, withZimg ? withHeadlessDeps
, withZlib ? withHeadlessDeps
, withZmq ? withFullDeps # Message passing

/*
 *  Licensing options (yes some are listed twice, filters and such are not listed)
 */
, withGPL ? true
, withGPLv3 ? true
, withUnfree ? false

/*
 *  Build options
 */
, withSmallBuild ? false # Optimize for size instead of speed
, withRuntimeCPUDetection ? true # Detect CPU capabilities at runtime (disable to compile natively)
, withGrayscale ? withFullDeps # Full grayscale support
, withSwscaleAlpha ? buildSwscale # Alpha channel support in swscale. You probably want this when buildSwscale.
, withHardcodedTables ? withHeadlessDeps # Hardcode decode tables instead of runtime generation
, withSafeBitstreamReader ? withHeadlessDeps # Buffer boundary checking in bitreaders
, withMultithread ? true # Multithreading via pthreads/win32 threads
, withNetwork ? withHeadlessDeps # Network support
, withPixelutils ? withHeadlessDeps # Pixel utils in libavutil
, withLTO ? false # build with link-time optimization
/*
 *  Program options
 */
, buildFfmpeg ? withHeadlessDeps # Build ffmpeg executable
, buildFfplay ? withFullDeps # Build ffplay executable
, buildFfprobe ? withHeadlessDeps # Build ffprobe executable
, buildQtFaststart ? withFullDeps # Build qt-faststart executable
, withBin ? buildFfmpeg || buildFfplay || buildFfprobe || buildQtFaststart
/*
 *  Library options
 */
, buildAvcodec ? withHeadlessDeps # Build avcodec library
, buildAvdevice ? withHeadlessDeps # Build avdevice library
, buildAvfilter ? withHeadlessDeps # Build avfilter library
, buildAvformat ? withHeadlessDeps # Build avformat library
# Deprecated but depended upon by some packages.
# https://github.com/NixOS/nixpkgs/pull/211834#issuecomment-1417435991)
, buildAvresample ? withHeadlessDeps && lib.versionOlder version "5" # Build avresample library
, buildAvutil ? withHeadlessDeps # Build avutil library
, buildPostproc ? withHeadlessDeps # Build postproc library
, buildSwresample ? withHeadlessDeps # Build swresample library
, buildSwscale ? withHeadlessDeps # Build swscale library
, withLib ? buildAvcodec
  || buildAvdevice
  || buildAvfilter
  || buildAvformat
  || buildAvutil
  || buildPostproc
  || buildSwresample
  || buildSwscale
/*
 *  Documentation options
 */
, withDocumentation ? withHtmlDoc || withManPages || withPodDoc || withTxtDoc
, withHtmlDoc ? withHeadlessDeps # HTML documentation pages
, withManPages ? withHeadlessDeps # Man documentation pages
, withPodDoc ? withHeadlessDeps # POD documentation pages
, withTxtDoc ? withHeadlessDeps # Text documentation pages
# Whether a "doc" output will be produced. Note that withManPages does not produce
# a "doc" output because its files go to "man".
, withDoc ? withDocumentation && (withHtmlDoc || withPodDoc || withTxtDoc)

/*
 *  Developer options
 */
, withDebug ? false
, withOptimisations ? true
, withExtraWarnings ? false
, withStripping ? false

/*
 *  External libraries options
 */
, alsa-lib
, bzip2
, clang
, celt
, dav1d
, fdk_aac
, fontconfig
, freetype
, frei0r
, fribidi
, game-music-emu
, gnutls
, gsm
, libjack2
, ladspaH
, lame
, libass
, libaom
, libbluray
, libbs2b
, libcaca
, libdc1394
, libraw1394
, libdrm
, libiconv
, intel-media-sdk
, libmodplug
, libmysofa
, libogg
, libopenmpt
, libopus
, librsvg
, libssh
, libtheora
, libv4l
, libva
, libva-minimal
, libvdpau
, libvmaf
, libvorbis
, libvpx
, libwebp
, libX11
, libxcb
, libXv
, libXext
, libxml2
, xz
, nv-codec-headers
, openal
, ocl-icd # OpenCL ICD
, opencl-headers  # OpenCL headers
, opencore-amr
, libGL
, libGLU
, openh264
, openjpeg
, libpulseaudio
, rav1e
, svt-av1
, rtmpdump
, samba
, SDL2
, soxr
, speex
, srt
, vid-stab
, vo-amrwbenc
, x264
, x265
, xavs
, xvidcore
, zeromq4
, zimg
, zlib
, vulkan-loader
, glslang
/*
 *  Darwin frameworks
 */
, AVFoundation
, Cocoa
, CoreAudio
, CoreMedia
, CoreServices
, MediaToolbox
, VideoDecodeAcceleration
, VideoToolbox
/*
 *  Testing
 */
, testers
}:

/* Maintainer notes:
 *
 * Version bumps:
 * It should always be safe to bump patch releases (e.g. 2.1.x, x being a patch release)
 * If adding a new branch, note any configure flags that were added, changed, or deprecated/removed
 *   and make the necessary changes.
 *
 * Known issues:
 * Cross-compiling will disable features not present on host OS
 *   (e.g. dxva2 support [DirectX] will not be enabled unless natively compiled on Cygwin)
 *
 */

let
  inherit (stdenv) isCygwin isDarwin isFreeBSD isLinux isAarch64;
  inherit (lib) optional optionals optionalString enableFeature;
in


assert lib.elem ffmpegVariant [ "headless" "small" "full" ];

/*
 *  Licensing dependencies
 */
assert withGPLv3 -> withGPL;
assert withUnfree -> withGPL && withGPLv3;
/*
 *  Build dependencies
 */
assert withPixelutils -> buildAvutil;
/*
 *  Program dependencies
 */
assert buildFfmpeg -> buildAvcodec
                     && buildAvfilter
                     && buildAvformat
                     && (buildSwresample || buildAvresample);
assert buildFfplay -> buildAvcodec
                     && buildAvformat
                     && buildSwscale
                     && (buildSwresample || buildAvresample);
assert buildFfprobe -> buildAvcodec && buildAvformat;
/*
 *  Library dependencies
 */
assert buildAvcodec -> buildAvutil; # configure flag since 0.6
assert buildAvdevice -> buildAvformat
                       && buildAvcodec
                       && buildAvutil; # configure flag since 0.6
assert buildAvformat -> buildAvcodec && buildAvutil; # configure flag since 0.6
assert buildPostproc -> buildAvutil;
assert buildSwscale -> buildAvutil;

stdenv.mkDerivation (finalAttrs: {
  pname = "ffmpeg" + (if ffmpegVariant == "small" then "" else "-${ffmpegVariant}");
  inherit version;

  src = fetchgit {
    url = "https://git.ffmpeg.org/ffmpeg.git";
    rev = "n${finalAttrs.version}";
    inherit sha256;
  };

  postPatch = ''
    patchShebangs .
  '' + lib.optionalString withFrei0r ''
    substituteInPlace libavfilter/vf_frei0r.c \
      --replace /usr/local/lib/frei0r-1 ${frei0r}/lib/frei0r-1
    substituteInPlace doc/filters.texi \
      --replace /usr/local/lib/frei0r-1 ${frei0r}/lib/frei0r-1
  '';

  patches = map (patch: fetchpatch patch) extraPatches;

  configurePlatforms = [];
  setOutputFlags = false; # Only accepts some of them
  configureFlags = [
    #mingw64 is internally treated as mingw32, so 32 and 64 make no difference here
    "--target_os=${if stdenv.hostPlatform.isMinGW then "mingw64" else stdenv.hostPlatform.parsed.kernel.name}"
    "--arch=${stdenv.hostPlatform.parsed.cpu.name}"
    "--pkg-config=${buildPackages.pkg-config.targetPrefix}pkg-config"
    /*
     *  Licensing flags
     */
    (enableFeature withGPL "gpl")
    (enableFeature withGPLv3 "version3")
    (enableFeature withUnfree "nonfree")
    /*
     *  Build flags
     */
    # On some ARM platforms --enable-thumb
    "--enable-shared"
    "--enable-pic"

    (enableFeature withSmallBuild "small")
    (enableFeature withRuntimeCPUDetection "runtime-cpudetect")
    (enableFeature withLTO "lto")
    (enableFeature withGrayscale "gray")
    (enableFeature withSwscaleAlpha "swscale-alpha")
    (enableFeature withHardcodedTables "hardcoded-tables")
    (enableFeature withSafeBitstreamReader "safe-bitstream-reader")

    (enableFeature (withMultithread && stdenv.targetPlatform.isUnix) "pthreads")
    (enableFeature (withMultithread && stdenv.targetPlatform.isWindows) "w32threads")
    "--disable-os2threads" # We don't support OS/2

    (enableFeature withNetwork "network")
    (enableFeature withPixelutils "pixelutils")

    "--datadir=${placeholder "data"}/share/ffmpeg"

    /*
     *  Program flags
     */
    (enableFeature buildFfmpeg "ffmpeg")
    (enableFeature buildFfplay "ffplay")
    (enableFeature buildFfprobe "ffprobe")
  ] ++ optionals withBin [
    "--bindir=${placeholder "bin"}/bin"
  ] ++ [
    /*
     *  Library flags
     */
    (enableFeature buildAvcodec "avcodec")
    (enableFeature buildAvdevice "avdevice")
    (enableFeature buildAvfilter "avfilter")
    (enableFeature buildAvformat "avformat")
  ] ++ optionals (lib.versionOlder version "5") [
    # Ffmpeg > 4 doesn't know about the flag anymore
    (enableFeature buildAvresample "avresample")
  ] ++ [
    (enableFeature buildAvutil "avutil")
    (enableFeature (buildPostproc && withGPL) "postproc")
    (enableFeature buildSwresample "swresample")
    (enableFeature buildSwscale "swscale")
  ] ++ optionals withLib [
    "--libdir=${placeholder "lib"}/lib"
    "--incdir=${placeholder "dev"}/include"
  ] ++ [
    /*
     *  Documentation flags
     */
    (enableFeature withDocumentation "doc")
    (enableFeature withHtmlDoc "htmlpages")
    (enableFeature withManPages "manpages")
  ] ++ optionals withManPages [
    "--mandir=${placeholder "man"}/share/man"
  ] ++ [
    (enableFeature withPodDoc "podpages")
    (enableFeature withTxtDoc "txtpages")
  ] ++ optionals withDoc [
    "--docdir=${placeholder "doc"}/share/doc/ffmpeg"
  ] ++ [
    /*
     *  External libraries
     */
    (enableFeature withAlsa "alsa")
    (enableFeature withBzlib "bzlib")
    (enableFeature withCelt "libcelt")
    (enableFeature withCuda "cuda")
    (enableFeature withCudaLLVM "cuda-llvm")
    (enableFeature withDav1d "libdav1d")
    (enableFeature withFdkAac "libfdk-aac")
    "--disable-libflite" # Force disable until a solution is found
    (enableFeature withFontconfig "fontconfig")
    (enableFeature withFreetype "libfreetype")
    (enableFeature withFrei0r "frei0r")
    (enableFeature withFribidi "libfribidi")
    (enableFeature withGme "libgme")
    (enableFeature withGnutls "gnutls")
    (enableFeature withGsm "libgsm")
    (enableFeature withLadspa "ladspa")
    (enableFeature withMp3lame "libmp3lame")
    (enableFeature withAom "libaom")
    (enableFeature withAss "libass")
    (enableFeature withBluray "libbluray")
    (enableFeature withBs2b "libbs2b")
    (enableFeature withDc1394 "libdc1394")
    (enableFeature withDrm "libdrm")
    (enableFeature withIconv "iconv")
    (enableFeature withJack "libjack")
    (enableFeature withMfx "libmfx")
    (enableFeature withModplug "libmodplug")
    (enableFeature withMysofa "libmysofa")
    (enableFeature withOpus "libopus")
    (enableFeature withSvg "librsvg")
    (enableFeature withSrt "libsrt")
    (enableFeature withSsh "libssh")
    (enableFeature withTheora "libtheora")
    (enableFeature withV4l2 "libv4l2")
    (enableFeature withV4l2M2m "v4l2-m2m")
    (enableFeature withVaapi "vaapi")
    (enableFeature withVdpau "vdpau")
    (enableFeature withVorbis "libvorbis")
    (enableFeature withVmaf "libvmaf")
    (enableFeature withVpx "libvpx")
    (enableFeature withWebp "libwebp")
    (enableFeature withXlib "xlib")
    (enableFeature withXcb "libxcb")
    (enableFeature withXcbShm "libxcb-shm")
    (enableFeature withXcbxfixes "libxcb-xfixes")
    (enableFeature withXcbShape "libxcb-shape")
    (enableFeature withXml2 "libxml2")
    (enableFeature withLzma "lzma")
    (enableFeature withNvdec "cuvid")
    (enableFeature withNvdec "nvdec")
    (enableFeature withNvenc "nvenc")
    (enableFeature withOpenal "openal")
    (enableFeature withOpencl "opencl")
    (enableFeature withOpencoreAmrnb "libopencore-amrnb")
    (enableFeature withOpengl "opengl")
    (enableFeature withOpenh264 "libopenh264")
    (enableFeature withOpenjpeg "libopenjpeg")
    (enableFeature withOpenmpt "libopenmpt")
    (enableFeature withPulse "libpulse")
    (enableFeature withRav1e "librav1e")
    (enableFeature withSvtav1 "libsvtav1")
    (enableFeature withRtmp "librtmp")
    (enableFeature withSdl2 "sdl2")
    (enableFeature withSoxr "libsoxr")
    (enableFeature withSpeex "libspeex")
    (enableFeature withVidStab "libvidstab") # Actual min. version 2.0
    (enableFeature withVoAmrwbenc "libvo-amrwbenc")
    (enableFeature withX264 "libx264")
    (enableFeature withX265 "libx265")
    (enableFeature withXavs "libxavs")
    (enableFeature withXvid "libxvid")
    (enableFeature withZmq "libzmq")
    (enableFeature withZimg "libzimg")
    (enableFeature withZlib "zlib")
    (enableFeature withVulkan "vulkan")
    (enableFeature withGlslang "libglslang")
    (enableFeature withSamba "libsmbclient")
    /*
     * Developer flags
     */
    (enableFeature withDebug "debug")
    (enableFeature withOptimisations "optimizations")
    (enableFeature withExtraWarnings "extra-warnings")
    (enableFeature withStripping "stripping")
  ] ++ optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "--cross-prefix=${stdenv.cc.targetPrefix}"
    "--enable-cross-compile"
    "--host-cc=${buildPackages.stdenv.cc}/bin/cc"
  ] ++ optionals stdenv.cc.isClang [
    "--cc=clang"
    "--cxx=clang++"
  ];

  # ffmpeg embeds the configureFlags verbatim in its binaries and because we
  # configure binary, include, library dir etc., this causes references in
  # outputs where we don't want them. Patch the generated config.h to remove all
  # such references except for data.
  postConfigure = let
    toStrip = lib.remove "data" finalAttrs.outputs; # We want to keep references to the data dir.
  in
    "remove-references-to ${lib.concatStringsSep " " (map (o: "-t ${placeholder o}") toStrip)} config.h";

  nativeBuildInputs = [ removeReferencesTo addOpenGLRunpath perl pkg-config texinfo yasm ];

  # TODO This was always in buildInputs before, why?
  buildInputs = optionals withFullDeps [ libdc1394 ]
  ++ optionals (withFullDeps && !stdenv.isDarwin) [ libraw1394 ] # TODO where does this belong to
  ++ optionals (withNvdec || withNvenc) [ nv-codec-headers ]
  ++ optionals withAlsa [ alsa-lib ]
  ++ optionals withAom [ libaom ]
  ++ optionals withAss [ libass ]
  ++ optionals withBluray [ libbluray ]
  ++ optionals withBs2b [ libbs2b ]
  ++ optionals withBzlib [ bzip2 ]
  ++ optionals withCaca [ libcaca ]
  ++ optionals withCelt [ celt ]
  ++ optionals withCudaLLVM [ clang ]
  ++ optionals withDav1d [ dav1d ]
  ++ optionals withDrm [ libdrm ]
  ++ optionals withFdkAac [ fdk_aac ]
  ++ optionals withFontconfig [ fontconfig ]
  ++ optionals withFreetype [ freetype ]
  ++ optionals withFrei0r [ frei0r ]
  ++ optionals withFribidi [ fribidi ]
  ++ optionals withGlslang [ glslang ]
  ++ optionals withGme [ game-music-emu ]
  ++ optionals withGnutls [ gnutls ]
  ++ optionals withGsm [ gsm ]
  ++ optionals withIconv [ libiconv ] # On Linux this should be in libc, do we really need it?
  ++ optionals withJack [ libjack2 ]
  ++ optionals withLadspa [ ladspaH ]
  ++ optionals withLzma [ xz ]
  ++ optionals withMfx [ intel-media-sdk ]
  ++ optionals withModplug [ libmodplug ]
  ++ optionals withMp3lame [ lame ]
  ++ optionals withMysofa [ libmysofa ]
  ++ optionals withOgg [ libogg ]
  ++ optionals withOpenal [ openal ]
  ++ optionals withOpencl [ ocl-icd opencl-headers ]
  ++ optionals withOpencoreAmrnb [ opencore-amr ]
  ++ optionals withOpengl [ libGL libGLU ]
  ++ optionals withOpenh264 [ openh264 ]
  ++ optionals withOpenjpeg [ openjpeg ]
  ++ optionals withOpenmpt [ libopenmpt ]
  ++ optionals withOpus [ libopus ]
  ++ optionals withPulse [ libpulseaudio ]
  ++ optionals withRav1e [ rav1e ]
  ++ optionals withRtmp [ rtmpdump ]
  ++ optionals withSamba [ samba ]
  ++ optionals withSdl2 [ SDL2 ]
  ++ optionals withSoxr [ soxr ]
  ++ optionals withSpeex [ speex ]
  ++ optionals withSrt [ srt ]
  ++ optionals withSsh [ libssh ]
  ++ optionals withSvg [ librsvg ]
  ++ optionals withSvtav1 [ svt-av1 ]
  ++ optionals withTheora [ libtheora ]
  ++ optionals withVaapi [ (if withSmallDeps then libva else libva-minimal) ]
  ++ optionals withVdpau [ libvdpau ]
  ++ optionals withVidStab [ vid-stab ]
  ++ optionals withVmaf [ libvmaf ]
  ++ optionals withVoAmrwbenc [ vo-amrwbenc ]
  ++ optionals withVorbis [ libvorbis ]
  ++ optionals withVpx [ libvpx ]
  ++ optionals withV4l2 [ libv4l ]
  ++ optionals withVulkan [ vulkan-loader ]
  ++ optionals withWebp [ libwebp ]
  ++ optionals withX264 [ x264 ]
  ++ optionals withX265 [ x265 ]
  ++ optionals withXavs [ xavs ]
  ++ optionals withXcb [ libxcb ]
  ++ optionals withXlib [ libX11 libXv libXext ]
  ++ optionals withXml2 [ libxml2 ]
  ++ optionals withXvid [ xvidcore ]
  ++ optionals withZimg [ zimg ]
  ++ optionals withZlib [ zlib ]
  ++ optionals withZmq [ zeromq4 ]
  ++ optionals stdenv.isDarwin [
    # TODO fine-grained flags
    AVFoundation
    Cocoa
    CoreAudio
    CoreMedia
    CoreServices
    MediaToolbox
    VideoDecodeAcceleration
    VideoToolbox
  ];

  buildFlags = [ "all" ]
    ++ optional buildQtFaststart "tools/qt-faststart"; # Build qt-faststart executable

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;

  # Fails with SIGABRT otherwise FIXME: Why?
  checkPhase = let
    ldLibraryPathEnv = if stdenv.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
    libsToLink = [ ]
      ++ optional buildAvcodec "libavcodec"
      ++ optional buildAvdevice "libavdevice"
      ++ optional buildAvfilter "libavfilter"
      ++ optional buildAvformat "libavformat"
      ++ optional buildAvresample "libavresample"
      ++ optional buildAvutil "libavutil"
      ++ optional buildPostproc "libpostproc"
      ++ optional buildSwresample "libswresample"
      ++ optional buildSwscale "libswscale"
    ;
  in ''
    ${ldLibraryPathEnv}="${lib.concatStringsSep ":" libsToLink}" make check -j$NIX_BUILD_CORES
  '';

  outputs = optionals withBin [ "bin" ] # The first output is the one that gets symlinked by default!
    ++ optionals withLib [ "lib" "dev" ]
    ++ optionals withDoc [ "doc" ]
    ++ optionals withManPages [ "man" ]
    ++ [ "data" "out" ] # We need an "out" output because we get an error otherwise. It's just an empty dir.
  ;

  postInstall = optionalString buildQtFaststart ''
    install -D tools/qt-faststart -t $bin/bin
  '';

  # Set RUNPATH so that libnvcuvid and libcuda in /run/opengl-driver(-32)/lib can be found.
  # See the explanation in addOpenGLRunpath.
  postFixup = optionalString stdenv.isLinux ''
    addOpenGLRunpath $out/lib/libavcodec.so
    addOpenGLRunpath $out/lib/libavutil.so
  '';

  enableParallelBuilding = true;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

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
    license = with licenses; [ lgpl21Plus ]
      ++ optional withGPL gpl2Plus
      ++ optional withGPLv3 gpl3Plus
      ++ optional withUnfree unfreeRedistributable;
    pkgConfigModules = [ "libavutil" ];
    platforms = platforms.all;
    maintainers = with maintainers; [ atemu ];
  };
})
