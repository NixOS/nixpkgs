{ lib, stdenv, buildPackages, removeReferencesTo, addOpenGLRunpath, pkg-config, perl, texinfo, yasm

  # You can fetch any upstream version using this derivation by specifying version and hash
  # NOTICE: Always use this argument to override the version. Do not use overrideAttrs.
, version # ffmpeg ABI version. Also declare this if you're overriding the source.
, hash ? "" # hash of the upstream source for the given ABI version
, source ? fetchgit {
    url = "https://git.ffmpeg.org/ffmpeg.git";
    rev = "n${version}";
    inherit hash;
  }

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
, fetchpatch2

  # Feature flags
, withAlsa ? withHeadlessDeps && stdenv.isLinux # Alsa in/output supporT
, withAom ? withFullDeps # AV1 reference encoder
, withAppKit ? withHeadlessDeps && stdenv.isDarwin # Apple AppKit framework
, withAribcaption ? withFullDeps && lib.versionAtLeast version "6.1" # ARIB STD-B24 Caption Decoder/Renderer
, withAss ? withHeadlessDeps && stdenv.hostPlatform == stdenv.buildPlatform # (Advanced) SubStation Alpha subtitle rendering
, withAudioToolbox ? withHeadlessDeps && stdenv.isDarwin # Apple AudioToolbox
, withAvFoundation ? withHeadlessDeps && stdenv.isDarwin # Apple AVFoundation framework
, withAvisynth ? withFullDeps # AviSynth script files reading
, withBluray ? withFullDeps # BluRay reading
, withBs2b ? withFullDeps # bs2b DSP library
, withBzlib ? withHeadlessDeps
, withCaca ? withFullDeps # Textual display (ASCII art)
, withCelt ? withFullDeps # CELT decoder
, withChromaprint ? withFullDeps # Audio fingerprinting
, withCodec2 ? withFullDeps # codec2 en/decoding
, withCoreImage ? withHeadlessDeps && stdenv.isDarwin # Apple CoreImage framework
, withCuda ? withFullDeps && withNvcodec
, withCudaLLVM ? withFullDeps
, withCuvid ? withHeadlessDeps && withNvcodec
, withDav1d ? withHeadlessDeps # AV1 decoder (focused on speed and correctness)
, withDc1394 ? withFullDeps && !stdenv.isDarwin # IIDC-1394 grabbing (ieee 1394)
, withDrm ? withHeadlessDeps && (with stdenv; isLinux || isFreeBSD) # libdrm support
, withDvdnav ? withFullDeps && withGPL && lib.versionAtLeast version "7" # needed for DVD demuxing
, withDvdread ? withFullDeps && withGPL && lib.versionAtLeast version "7" # needed for DVD demuxing
, withFdkAac ? withFullDeps && (!withGPL || withUnfree) # Fraunhofer FDK AAC de/encoder
, withNvcodec ? withHeadlessDeps && (with stdenv; !isDarwin && !isAarch32 && !hostPlatform.isRiscV && hostPlatform == buildPlatform) # dynamically linked Nvidia code
, withFlite ? withFullDeps # Voice Synthesis
, withFontconfig ? withHeadlessDeps # Needed for drawtext filter
, withFreetype ? withHeadlessDeps # Needed for drawtext filter
, withFrei0r ? withFullDeps && withGPL # frei0r video filtering
, withFribidi ? withFullDeps # Needed for drawtext filter
, withGme ? withFullDeps # Game Music Emulator
, withGnutls ? withHeadlessDeps
, withGsm ? withFullDeps # GSM de/encoder
, withHarfbuzz ? withHeadlessDeps && lib.versionAtLeast version "6.1" # Needed for drawtext filter
, withIconv ? withHeadlessDeps
, withJack ? withFullDeps && !stdenv.isDarwin # Jack audio
, withJxl ? withFullDeps && lib.versionAtLeast version "5" # JPEG XL de/encoding
, withLadspa ? withFullDeps # LADSPA audio filtering
, withLzma ? withHeadlessDeps # xz-utils
, withMfx ? withFullDeps && (with stdenv.hostPlatform; isLinux && !isAarch) # Hardware acceleration via intel-media-sdk/libmfx
, withModplug ? withFullDeps && !stdenv.isDarwin # ModPlug support
, withMp3lame ? withHeadlessDeps # LAME MP3 encoder
, withMysofa ? withFullDeps # HRTF support via SOFAlizer
, withNvdec ? withHeadlessDeps && withNvcodec
, withNvenc ? withHeadlessDeps && withNvcodec
, withOgg ? withHeadlessDeps # Ogg container used by vorbis & theora
, withOpenal ? withFullDeps # OpenAL 1.1 capture support
, withOpencl ? withFullDeps
, withOpencoreAmrnb ? withFullDeps && withVersion3 # AMR-NB de/encoder
, withOpencoreAmrwb ? withFullDeps && withVersion3 # AMR-WB decoder
, withOpengl ? withFullDeps && !stdenv.isDarwin # OpenGL rendering
, withOpenh264 ? withFullDeps # H.264/AVC encoder
, withOpenjpeg ? withFullDeps # JPEG 2000 de/encoder
, withOpenmpt ? withFullDeps # Tracked music files decoder
, withOpus ? withHeadlessDeps # Opus de/encoder
, withPlacebo ? withFullDeps && !stdenv.isDarwin # libplacebo video processing library
, withPulse ? withSmallDeps && stdenv.isLinux # Pulseaudio input support
, withQrencode ? withFullDeps && lib.versionAtLeast version "7" # QR encode generation
, withQuirc ? withFullDeps && lib.versionAtLeast version "7" # QR decoding
, withRav1e ? withFullDeps # AV1 encoder (focused on speed and safety)
, withRtmp ? withFullDeps # RTMP[E] support
, withSamba ? withFullDeps && !stdenv.isDarwin && withGPLv3 # Samba protocol
, withSdl2 ? withSmallDeps
, withShaderc ? withFullDeps && !stdenv.isDarwin && lib.versionAtLeast version "5.0"
, withSoxr ? withHeadlessDeps # Resampling via soxr
, withSpeex ? withHeadlessDeps # Speex de/encoder
, withSrt ? withHeadlessDeps # Secure Reliable Transport (SRT) protocol
, withSsh ? withHeadlessDeps # SFTP protocol
, withSvg ? withFullDeps # SVG protocol
, withSvtav1 ? withHeadlessDeps && !stdenv.isAarch64 && !stdenv.hostPlatform.isMinGW # AV1 encoder/decoder (focused on speed and correctness)
, withTensorflow ? false # Tensorflow dnn backend support (Increases closure size by ~390 MiB)
, withTheora ? withHeadlessDeps # Theora encoder
, withV4l2 ? withHeadlessDeps && stdenv.isLinux  # Video 4 Linux support
, withV4l2M2m ? withV4l2
, withVaapi ? withHeadlessDeps && (with stdenv; isLinux || isFreeBSD) # Vaapi hardware acceleration
, withVdpau ? withSmallDeps && !stdenv.hostPlatform.isMinGW # Vdpau hardware acceleration
, withVideoToolbox ? withHeadlessDeps && stdenv.isDarwin # Apple VideoToolbox
, withVidStab ? withFullDeps && withGPL # Video stabilization
, withVmaf ? withFullDeps && !stdenv.isAarch64 && lib.versionAtLeast version "5" # Netflix's VMAF (Video Multi-Method Assessment Fusion)
, withVoAmrwbenc ? withFullDeps && withVersion3 # AMR-WB encoder
, withVorbis ? withHeadlessDeps # Vorbis de/encoding, native encoder exists
, withVpl ? false # Hardware acceleration via intel libvpl
, withVpx ? withHeadlessDeps && stdenv.buildPlatform == stdenv.hostPlatform # VP8 & VP9 de/encoding
, withVulkan ? withSmallDeps && !stdenv.isDarwin
, withWebp ? withFullDeps # WebP encoder
, withX264 ? withHeadlessDeps && withGPL # H.264/AVC encoder
, withX265 ? withHeadlessDeps && withGPL # H.265/HEVC encoder
, withXavs ? withFullDeps && withGPL # AVS encoder
, withXcb ? withXcbShm || withXcbxfixes || withXcbShape # X11 grabbing using XCB
, withXcbShape ? withFullDeps # X11 grabbing shape rendering
, withXcbShm ? withFullDeps # X11 grabbing shm communication
, withXcbxfixes ? withFullDeps # X11 grabbing mouse rendering
, withXevd ? withFullDeps && lib.versionAtLeast version "7" && stdenv.hostPlatform.isx86 # MPEG-5 EVC decoding
, withXeve ? withFullDeps && lib.versionAtLeast version "7" && stdenv.hostPlatform.isx86 # MPEG-5 EVC encoding
, withXlib ? withFullDeps # Xlib support
, withXml2 ? withFullDeps # libxml2 support, for IMF and DASH demuxers
, withXvid ? withHeadlessDeps && withGPL # Xvid encoder, native encoder exists
, withZimg ? withHeadlessDeps
, withZlib ? withHeadlessDeps
, withZmq ? withFullDeps # Message passing

/*
 *  Licensing options (yes some are listed twice, filters and such are not listed)
 */
, withGPL ? true
, withVersion3 ? true # When withGPL is set this implies GPLv3 otherwise it is LGPLv3
, withGPLv3 ? withGPL && withVersion3
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
, withStatic ? stdenv.hostPlatform.isStatic
, withShared ? !stdenv.hostPlatform.isStatic
, withPic ? true
, withThumb ? false # On some ARM platforms

/*
 *  Program options
 */
, buildFfmpeg ? withHeadlessDeps # Build ffmpeg executable
, buildFfplay ? withSmallDeps # Build ffplay executable
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
, avisynthplus
, bzip2
, celt
, chromaprint
, codec2
, clang
, dav1d
, fdk_aac
, flite
, fontconfig
, freetype
, frei0r
, fribidi
, game-music-emu
, gnutls
, gsm
, harfbuzz
, intel-media-sdk
, ladspaH
, lame
, libaom
, libaribcaption
, libass
, libbluray
, libbs2b
, libcaca
, libdc1394
, libdrm
, libdvdnav
, libdvdread
, libGL
, libGLU
, libiconv
, libjack2
, libjxl
, libmodplug
, libmysofa
, libogg
, libopenmpt
, libopus
, libplacebo
, libplacebo_5
, libpulseaudio
, libraw1394
, librsvg
, libssh
, libtensorflow
, libtheora
, libv4l
, libva
, libva-minimal
, libvdpau
, libvmaf
, libvorbis
, libvpl
, libvpx
, libwebp
, libX11
, libxcb
, libXext
, libxml2
, libXv
, nv-codec-headers
, nv-codec-headers-12
, ocl-icd # OpenCL ICD
, openal
, opencl-headers  # OpenCL headers
, opencore-amr
, openh264
, openjpeg
, qrencode
, quirc
, rav1e
, rtmpdump
, samba
, SDL2
, shaderc
, soxr
, speex
, srt
, svt-av1
, vid-stab
, vo-amrwbenc
, vulkan-headers
, vulkan-loader
, x264
, x265
, xavs
, xevd
, xeve
, xvidcore
, xz
, zeromq4
, zimg
, zlib
/*
 *  Darwin frameworks
 */
, AppKit
, AudioToolbox
, AVFoundation
, CoreImage
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
  inherit (lib) optional optionals optionalString enableFeature versionOlder versionAtLeast;
in


assert lib.elem ffmpegVariant [ "headless" "small" "full" ];

/*
 *  Licensing dependencies
 */
assert withGPLv3 -> withGPL && withVersion3;

/*
 *  Build dependencies
 */
assert withPixelutils -> buildAvutil;
assert !(withMfx && withVpl); # incompatible features
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

/*
 *  External Library dependencies
 */
assert (withCuda || withCuvid || withNvdec  || withNvenc) -> withNvcodec;

stdenv.mkDerivation (finalAttrs: {
  pname = "ffmpeg" + (optionalString (ffmpegVariant != "small") "-${ffmpegVariant}");
  inherit version;
  src = source;

  postPatch = ''
    patchShebangs .
  '' + lib.optionalString withFrei0r ''
    substituteInPlace libavfilter/vf_frei0r.c \
      --replace /usr/local/lib/frei0r-1 ${frei0r}/lib/frei0r-1
    substituteInPlace doc/filters.texi \
      --replace /usr/local/lib/frei0r-1 ${frei0r}/lib/frei0r-1
  '';

  patches = map (patch: fetchpatch2 patch) ([ ]
    ++ optionals (versionOlder version "5") [
      {
        name = "libsvtav1-1.5.0-compat-compressed_ten_bit_format.patch";
        url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/031f1561cd286596cdb374da32f8aa816ce3b135";
        hash = "sha256-agJgzIzrBTQBAypuCmGXXFo7vw6Iodw5Ny5O5QCKCn8=";
      }
      {
        # Backport fix for binutils-2.41.
        name = "binutils-2.41.patch";
        url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/effadce6c756247ea8bae32dc13bb3e6f464f0eb";
        hash = "sha256-vLSltvZVMcQ0CnkU0A29x6fJSywE8/aU+Mp9os8DZYY=";
      }
      # The upstream patch isn’t for ffmpeg 4, but it will apply with a few tweaks.
      # Fixes a crash when built with clang 16 due to UB in ff_seek_frame_binary.
      {
        name = "utils-fix_crash_in_ff_seek_frame_binary.patch";
        url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/ab792634197e364ca1bb194f9abe36836e42f12d";
        hash = "sha256-vqqVACjbCcGL9Qvmg1QArSKqVmOqr8BEr+OxTBDt6mA=";
        postFetch = ''
          substituteInPlace "$out" \
            --replace libavformat/seek.c libavformat/utils.c \
            --replace 'const AVInputFormat *const ' 'const AVInputFormat *'
        '';
      }
    ]
    ++ (lib.optionals (lib.versionAtLeast version "5" && lib.versionOlder version "6") [
      {
        name = "fix_build_failure_due_to_libjxl_version_to_new";
        url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/75b1a555a70c178a9166629e43ec2f6250219eb2";
        hash = "sha256-+2kzfPJf5piim+DqEgDuVEEX5HLwRsxq0dWONJ4ACrU=";
      }
      {
        name = "5.x-CVE-2024-31585.patch";
        url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/8711cea3841fc385cccb1e7255176479e865cd4d";
        hash = "sha256-WT+ly/l04yM/tRVbhkESA3sDDjwvtd/Cg2y8tQo4ApI=";
      }
      {
        name = "CVE-2024-31582.patch";
        url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/99debe5f823f45a482e1dc08de35879aa9c74bd2";
        hash = "sha256-+CQ9FXR6Vr/AmsbXFiCUXZcxKj1s8nInEdke/Oc/kUA=";
      }
      {
        name = "CVE-2024-31578.patch";
        url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/3bb00c0a420c3ce83c6fafee30270d69622ccad7";
        hash = "sha256-oZMZysBA+/gwaGEM1yvI+8wCadXWE7qLRL6Emap3b8Q=";
      }
    ])
    ++ (lib.optionals (lib.versionAtLeast version "6.1" && lib.versionOlder version "6.2") [
      { # this can be removed post 6.1
        name = "fix_build_failure_due_to_PropertyKey_EncoderID";
        url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/cb049d377f54f6b747667a93e4b719380c3e9475";
        hash = "sha256-sxRXKKgUak5vsQTiV7ge8vp+N22CdTIvuczNgVRP72c=";
      }
      {
        name = "fix_vulkan_av1";
        url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/e06ce6d2b45edac4a2df04f304e18d4727417d24";
        hash = "sha256-73mlX1rdJrguw7OXaSItfHtI7gflDrFj+7SepVvvUIg=";
      }
      {
        name = "CVE-2024-31582.patch";
        url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/99debe5f823f45a482e1dc08de35879aa9c74bd2";
        hash = "sha256-+CQ9FXR6Vr/AmsbXFiCUXZcxKj1s8nInEdke/Oc/kUA=";
      }
      {
        name = "CVE-2024-31578.patch";
        url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/3bb00c0a420c3ce83c6fafee30270d69622ccad7";
        hash = "sha256-oZMZysBA+/gwaGEM1yvI+8wCadXWE7qLRL6Emap3b8Q=";
      }
    ])
    ++ (lib.optionals (lib.versionAtLeast version "7.0" && lib.versionOlder version "7.0.1") [
      {
        # Will likely be obsolete in >7.0
        name = "fate_avoid_dependency_on_samples";
        url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/7b7b7819bd21cc92ac07f6696b0e7f26fa8f9834";
        hash = "sha256-TKI289XqtG86Sj9s7mVYvmkjAuRXeK+2cYYEDkg6u6I=";
      }
    ]));

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
    (enableFeature withVersion3 "version3")
    (enableFeature withUnfree "nonfree")
    /*
     *  Build flags
     */
    (enableFeature withStatic "static")
    (enableFeature withShared "shared")
    (enableFeature withPic "pic")
    (enableFeature withThumb "thumb")

    (enableFeature withSmallBuild "small")
    (enableFeature withRuntimeCPUDetection "runtime-cpudetect")
    (enableFeature withGrayscale "gray")
    (enableFeature withSwscaleAlpha "swscale-alpha")
    (enableFeature withHardcodedTables "hardcoded-tables")
    (enableFeature withSafeBitstreamReader "safe-bitstream-reader")

    (enableFeature (withMultithread && stdenv.hostPlatform.isUnix) "pthreads")
    (enableFeature (withMultithread && stdenv.hostPlatform.isWindows) "w32threads")
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
    (enableFeature withAom "libaom")
    (enableFeature withAppKit "appkit")
  ] ++ optionals (versionAtLeast version "6.1") [
    (enableFeature withAribcaption "libaribcaption")
  ] ++ [
    (enableFeature withAss "libass")
    (enableFeature withAudioToolbox "audiotoolbox")
    (enableFeature withAvFoundation "avfoundation")
    (enableFeature withAvisynth "avisynth")
    (enableFeature withBluray "libbluray")
    (enableFeature withBs2b "libbs2b")
    (enableFeature withBzlib "bzlib")
    (enableFeature withCaca "libcaca")
    (enableFeature withCelt "libcelt")
    (enableFeature withChromaprint "chromaprint")
    (enableFeature withCodec2 "libcodec2")
    (enableFeature withCoreImage "coreimage")
    (enableFeature withCuda "cuda")
    (enableFeature withCudaLLVM "cuda-llvm")
    (enableFeature withCuvid "cuvid")
    (enableFeature withDav1d "libdav1d")
    (enableFeature withDc1394 "libdc1394")
    (enableFeature withDrm "libdrm")
  ] ++ optionals (versionAtLeast version "7") [
    (enableFeature withDvdnav "libdvdnav")
    (enableFeature withDvdread "libdvdread")
  ] ++ [
    (enableFeature withFdkAac "libfdk-aac")
    (enableFeature withNvcodec "ffnvcodec")
    (enableFeature withFlite "libflite")
    (enableFeature withFontconfig "fontconfig")
    (enableFeature withFontconfig "libfontconfig")
    (enableFeature withFreetype "libfreetype")
    (enableFeature withFrei0r "frei0r")
    (enableFeature withFribidi "libfribidi")
    (enableFeature withGme "libgme")
    (enableFeature withGnutls "gnutls")
    (enableFeature withGsm "libgsm")
  ] ++ optionals (versionAtLeast version "6.1") [
    (enableFeature withHarfbuzz "libharfbuzz")
  ] ++ [
    (enableFeature withIconv "iconv")
    (enableFeature withJack "libjack")
  ] ++ optionals (versionAtLeast finalAttrs.version "5.0") [
    (enableFeature withJxl "libjxl")
  ] ++ [
    (enableFeature withLadspa "ladspa")
    (enableFeature withLzma "lzma")
    (enableFeature withMfx "libmfx")
    (enableFeature withModplug "libmodplug")
    (enableFeature withMp3lame "libmp3lame")
    (enableFeature withMysofa "libmysofa")
    (enableFeature withNvdec "nvdec")
    (enableFeature withNvenc "nvenc")
    (enableFeature withOpenal "openal")
    (enableFeature withOpencl "opencl")
    (enableFeature withOpencoreAmrnb "libopencore-amrnb")
    (enableFeature withOpencoreAmrwb "libopencore-amrwb")
    (enableFeature withOpengl "opengl")
    (enableFeature withOpenh264 "libopenh264")
    (enableFeature withOpenjpeg "libopenjpeg")
    (enableFeature withOpenmpt "libopenmpt")
    (enableFeature withOpus "libopus")
  ] ++ optionals (versionAtLeast version "5.0") [
    (enableFeature withPlacebo "libplacebo")
  ] ++ [
    (enableFeature withPulse "libpulse")
  ] ++ optionals (versionAtLeast version "7") [
    (enableFeature withQrencode "libqrencode")
    (enableFeature withQuirc "libquirc")
  ] ++ [
    (enableFeature withRav1e "librav1e")
    (enableFeature withRtmp "librtmp")
    (enableFeature withSamba "libsmbclient")
    (enableFeature withSdl2 "sdl2")
  ] ++ optionals (versionAtLeast version "5.0") [
    (enableFeature withShaderc "libshaderc")
  ] ++ [
    (enableFeature withSoxr "libsoxr")
    (enableFeature withSpeex "libspeex")
    (enableFeature withSrt "libsrt")
    (enableFeature withSsh "libssh")
    (enableFeature withSvg "librsvg")
    (enableFeature withSvtav1 "libsvtav1")
    (enableFeature withTensorflow "libtensorflow")
    (enableFeature withTheora "libtheora")
    (enableFeature withV4l2 "libv4l2")
    (enableFeature withV4l2M2m "v4l2-m2m")
    (enableFeature withVaapi "vaapi")
    (enableFeature withVdpau "vdpau")
  ] ++ optionals (versionAtLeast version "6.0")  [
    (enableFeature withVpl "libvpl")
  ] ++ [
    (enableFeature withVideoToolbox "videotoolbox")
    (enableFeature withVidStab "libvidstab") # Actual min. version 2.0
    (enableFeature withVmaf "libvmaf")
    (enableFeature withVoAmrwbenc "libvo-amrwbenc")
    (enableFeature withVorbis "libvorbis")
    (enableFeature withVpx "libvpx")
    (enableFeature withVulkan "vulkan")
    (enableFeature withWebp "libwebp")
    (enableFeature withX264 "libx264")
    (enableFeature withX265 "libx265")
    (enableFeature withXavs "libxavs")
    (enableFeature withXcb "libxcb")
    (enableFeature withXcbShape "libxcb-shape")
    (enableFeature withXcbShm "libxcb-shm")
    (enableFeature withXcbxfixes "libxcb-xfixes")
  ] ++ optionals (versionAtLeast version "7")  [
    (enableFeature withXevd "libxevd")
    (enableFeature withXeve "libxeve")
  ] ++ [
    (enableFeature withXlib "xlib")
    (enableFeature withXml2 "libxml2")
    (enableFeature withXvid "libxvid")
    (enableFeature withZimg "libzimg")
    (enableFeature withZlib "zlib")
    (enableFeature withZmq "libzmq")
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
    toStrip = map placeholder (lib.remove "data" finalAttrs.outputs) # We want to keep references to the data dir.
      ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) buildPackages.stdenv.cc;
  in
    "remove-references-to ${lib.concatStringsSep " " (map (o: "-t ${o}") toStrip)} config.h";

  strictDeps = true;

  nativeBuildInputs = [ removeReferencesTo addOpenGLRunpath perl pkg-config texinfo yasm ]
  ++ optionals withCudaLLVM [ clang ];

  buildInputs = []
  ++ optionals withAlsa [ alsa-lib ]
  ++ optionals withAom [ libaom ]
  ++ optionals withAppKit [ AppKit ]
  ++ optionals withAribcaption [ libaribcaption ]
  ++ optionals withAss [ libass ]
  ++ optionals withAudioToolbox [ AudioToolbox ]
  ++ optionals withAvFoundation [ AVFoundation ]
  ++ optionals withAvisynth [ avisynthplus ]
  ++ optionals withBluray [ libbluray ]
  ++ optionals withBs2b [ libbs2b ]
  ++ optionals withBzlib [ bzip2 ]
  ++ optionals withCaca [ libcaca ]
  ++ optionals withCelt [ celt ]
  ++ optionals withChromaprint [ chromaprint ]
  ++ optionals withCodec2 [ codec2 ]
  ++ optionals withCoreImage [ CoreImage ]
  ++ optionals withDav1d [ dav1d ]
  ++ optionals withDc1394 [ libdc1394 libraw1394 ]
  ++ optionals withDrm [ libdrm ]
  ++ optionals withDvdnav [ libdvdnav ]
  ++ optionals withDvdread [ libdvdread ]
  ++ optionals withFdkAac [ fdk_aac ]
  ++ optionals withNvcodec [ (if (lib.versionAtLeast version "6") then nv-codec-headers-12 else nv-codec-headers) ]
  ++ optionals withFlite [ flite ]
  ++ optionals withFontconfig [ fontconfig ]
  ++ optionals withFreetype [ freetype ]
  ++ optionals withFrei0r [ frei0r ]
  ++ optionals withFribidi [ fribidi ]
  ++ optionals withGme [ game-music-emu ]
  ++ optionals withGnutls [ gnutls ]
  ++ optionals withGsm [ gsm ]
  ++ optionals withHarfbuzz [ harfbuzz ]
  ++ optionals withIconv [ libiconv ] # On Linux this should be in libc, do we really need it?
  ++ optionals withJack [ libjack2 ]
  ++ optionals withJxl [ libjxl ]
  ++ optionals withLadspa [ ladspaH ]
  ++ optionals withLzma [ xz ]
  ++ optionals withMfx [ intel-media-sdk ]
  ++ optionals withModplug [ libmodplug ]
  ++ optionals withMp3lame [ lame ]
  ++ optionals withMysofa [ libmysofa ]
  ++ optionals withOgg [ libogg ]
  ++ optionals withOpenal [ openal ]
  ++ optionals withOpencl [ ocl-icd opencl-headers ]
  ++ optionals (withOpencoreAmrnb || withOpencoreAmrwb) [ opencore-amr ]
  ++ optionals withOpengl [ libGL libGLU ]
  ++ optionals withOpenh264 [ openh264 ]
  ++ optionals withOpenjpeg [ openjpeg ]
  ++ optionals withOpenmpt [ libopenmpt ]
  ++ optionals withOpus [ libopus ]
  ++ optionals withPlacebo [ (if (lib.versionAtLeast version "6.1") then libplacebo else libplacebo_5) vulkan-headers ]
  ++ optionals withPulse [ libpulseaudio ]
  ++ optionals withQrencode [ qrencode ]
  ++ optionals withQuirc [ quirc ]
  ++ optionals withRav1e [ rav1e ]
  ++ optionals withRtmp [ rtmpdump ]
  ++ optionals withSamba [ samba ]
  ++ optionals withSdl2 [ SDL2 ]
  ++ optionals withShaderc [ shaderc ]
  ++ optionals withSoxr [ soxr ]
  ++ optionals withSpeex [ speex ]
  ++ optionals withSrt [ srt ]
  ++ optionals withSsh [ libssh ]
  ++ optionals withSvg [ librsvg ]
  ++ optionals withSvtav1 [ svt-av1 ]
  ++ optionals withTensorflow [ libtensorflow ]
  ++ optionals withTheora [ libtheora ]
  ++ optionals withV4l2 [ libv4l ]
  ++ optionals withVaapi [ (if withSmallDeps then libva else libva-minimal) ]
  ++ optionals withVdpau [ libvdpau ]
  ++ optionals withVideoToolbox [ VideoToolbox ]
  ++ optionals withVidStab [ vid-stab ]
  ++ optionals withVmaf [ libvmaf ]
  ++ optionals withVoAmrwbenc [ vo-amrwbenc ]
  ++ optionals withVorbis [ libvorbis ]
  ++ optionals withVpl [ libvpl ]
  ++ optionals withVpx [ libvpx ]
  ++ optionals withVulkan [ vulkan-headers vulkan-loader ]
  ++ optionals withWebp [ libwebp ]
  ++ optionals withX264 [ x264 ]
  ++ optionals withX265 [ x265 ]
  ++ optionals withXavs [ xavs ]
  ++ optionals withXcb [ libxcb ]
  ++ optionals withXevd [ xevd ]
  ++ optionals withXeve [ xeve ]
  ++ optionals withXlib [ libX11 libXv libXext ]
  ++ optionals withXml2 [ libxml2 ]
  ++ optionals withXvid [ xvidcore ]
  ++ optionals withZimg [ zimg ]
  ++ optionals withZlib [ zlib ]
  ++ optionals withZmq [ zeromq4 ]
  ;

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
  postFixup = optionalString (stdenv.isLinux && withLib) ''
    addOpenGLRunpath ${placeholder "lib"}/lib/libavcodec.so
    addOpenGLRunpath ${placeholder "lib"}/lib/libavutil.so
  ''
  # https://trac.ffmpeg.org/ticket/10809
  + optionalString (versionAtLeast version "5.0" && withVulkan && !stdenv.hostPlatform.isMinGW) ''
    patchelf $lib/lib/libavcodec.so --add-needed libvulkan.so --add-rpath ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  enableParallelBuilding = true;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "Complete, cross-platform solution to record, convert and stream audio and video";
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
      ++ optional withVersion3 lgpl3Plus
      ++ optional withGPLv3 gpl3Plus
      ++ optional withUnfree unfreeRedistributable
      ++ optional (withGPL && withUnfree) unfree;
    pkgConfigModules = [ ]
      ++ optional buildAvcodec "libavcodec"
      ++ optional buildAvdevice "libavdevice"
      ++ optional buildAvfilter "libavfilter"
      ++ optional buildAvformat "libavformat"
      ++ optional buildAvresample "libavresample"
      ++ optional buildAvutil "libavutil"
      ++ optional buildPostproc "libpostproc"
      ++ optional buildSwresample "libswresample"
      ++ optional buildSwscale "libswscale";
    platforms = platforms.all;
    # See https://github.com/NixOS/nixpkgs/pull/295344#issuecomment-1992263658
    broken = stdenv.hostPlatform.isMinGW && stdenv.hostPlatform.is64bit;
    maintainers = with maintainers; [ atemu arthsmn jopejoe1 ];
    mainProgram = "ffmpeg";
  };
})
