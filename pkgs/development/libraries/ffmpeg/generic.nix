{
  lib,
  config,
  stdenv,
  buildPackages,
  removeReferencesTo,
  addDriverRunpath,
  pkg-config,
  perl,
  texinfo,
  texinfo6,
  yasm,
  nasm,

  # You can fetch any upstream version using this derivation by specifying version and hash
  # NOTICE: Always use this argument to override the version. Do not use overrideAttrs.
  version, # ffmpeg ABI version. Also declare this if you're overriding the source.
  hash ? "", # hash of the upstream source for the given ABI version
  source ? fetchgit {
    url = "https://git.ffmpeg.org/ffmpeg.git";
    rev = "n${version}";
    inherit hash;
  },

  ffmpegVariant ? "small", # Decides which dependencies are enabled by default

  # Build with headless deps; excludes dependencies that are only necessary for
  # GUI applications. To be used for purposes that don't generally need such
  # components and i.e. only depend on libav
  withHeadlessDeps ? ffmpegVariant == "headless" || withSmallDeps,

  # Dependencies a user might customarily expect from a regular ffmpeg build.
  # /All/ packages that depend on ffmpeg and some of its feaures should depend
  # on the small variant. Small means the minimal set of features that satisfies
  # all dependants in Nixpkgs
  withSmallDeps ? ffmpegVariant == "small" || withFullDeps,

  # Everything enabled; only guarded behind platform exclusivity or brokenness.
  # If you need to depend on ffmpeg-full because ffmpeg is missing some feature
  # your package needs, you should enable that feature in regular ffmpeg
  # instead.
  withFullDeps ? ffmpegVariant == "full",

  fetchgit,
  fetchpatch2,

  # Feature flags
  withAlsa ? withHeadlessDeps && stdenv.hostPlatform.isLinux, # Alsa in/output supporT
  withAmf ? withHeadlessDeps && lib.meta.availableOn stdenv.hostPlatform amf, # AMD Media Framework video encoding
  withAom ? withHeadlessDeps, # AV1 reference encoder
  withAribb24 ? withFullDeps, # ARIB text and caption decoding
  withAribcaption ? withFullDeps && lib.versionAtLeast version "6.1", # ARIB STD-B24 Caption Decoder/Renderer
  withAss ? withHeadlessDeps && stdenv.hostPlatform == stdenv.buildPlatform, # (Advanced) SubStation Alpha subtitle rendering
  withAvisynth ? withFullDeps, # AviSynth script files reading
  withBluray ? withHeadlessDeps, # BluRay reading
  withBs2b ? withFullDeps, # bs2b DSP library
  withBzlib ? withHeadlessDeps,
  withCaca ? withFullDeps, # Textual display (ASCII art)
  withCdio ? withFullDeps && withGPL, # Audio CD grabbing
  withCelt ? withFullDeps, # CELT decoder
  withChromaprint ? withFullDeps, # Audio fingerprinting
  withCodec2 ? withFullDeps, # codec2 en/decoding
  withCuda ? withFullDeps && withNvcodec,
  withCudaLLVM ? withHeadlessDeps,
  withCudaNVCC ? withFullDeps && withUnfree && config.cudaSupport,
  withCuvid ? withHeadlessDeps && withNvcodec,
  withDav1d ? withHeadlessDeps, # AV1 decoder (focused on speed and correctness)
  withDavs2 ? withFullDeps && withGPL, # AVS2 decoder
  withDc1394 ? withFullDeps && !stdenv.hostPlatform.isDarwin, # IIDC-1394 grabbing (ieee 1394)
  withDrm ? withHeadlessDeps && (with stdenv; isLinux || isFreeBSD), # libdrm support
  withDvdnav ? withFullDeps && withGPL && lib.versionAtLeast version "7", # needed for DVD demuxing
  withDvdread ? withFullDeps && withGPL && lib.versionAtLeast version "7", # needed for DVD demuxing
  withFdkAac ? withFullDeps && (!withGPL || withUnfree), # Fraunhofer FDK AAC de/encoder
  withNvcodec ?
    withHeadlessDeps
    && (
      with stdenv;
      !isDarwin
      && !isAarch32
      && !hostPlatform.isLoongArch64
      && !hostPlatform.isRiscV
      && hostPlatform == buildPlatform
    ), # dynamically linked Nvidia code
  withFlite ? withFullDeps, # Voice Synthesis
  withFontconfig ? withHeadlessDeps, # Needed for drawtext filter
  withFreetype ? withHeadlessDeps, # Needed for drawtext filter
  withFrei0r ? withFullDeps && withGPL, # frei0r video filtering
  withFribidi ? withHeadlessDeps, # Needed for drawtext filter
  withGme ? withFullDeps, # Game Music Emulator
  withGmp ? withHeadlessDeps && withVersion3, # rtmp(t)e support
  withGnutls ? withHeadlessDeps,
  withGsm ? withFullDeps, # GSM de/encoder
  withHarfbuzz ? withHeadlessDeps && lib.versionAtLeast version "6.1", # Needed for drawtext filter
  withIconv ? withHeadlessDeps,
  withIlbc ? withFullDeps, # iLBC de/encoding
  withJack ? withFullDeps && !stdenv.hostPlatform.isDarwin, # Jack audio
  withJxl ? withFullDeps && lib.versionAtLeast version "5", # JPEG XL de/encoding
  withKvazaar ? withFullDeps, # HEVC encoding
  withLadspa ? withFullDeps, # LADSPA audio filtering
  withLc3 ? withFullDeps && lib.versionAtLeast version "7.1", # LC3 de/encoding
  withLcevcdec ? withFullDeps && lib.versionAtLeast version "7.1", # LCEVC decoding
  withLcms2 ? withFullDeps, # ICC profile support via lcms2
  withLzma ? withHeadlessDeps, # xz-utils
  withMetal ? false, # Unfree and requires manual downloading of files
  withMfx ? false, # Hardware acceleration via intel-media-sdk/libmfx
  withModplug ? withFullDeps && !stdenv.hostPlatform.isDarwin, # ModPlug support
  withMp3lame ? withHeadlessDeps, # LAME MP3 encoder
  withMysofa ? withFullDeps, # HRTF support via SOFAlizer
  withNpp ? withFullDeps && withUnfree && config.cudaSupport, # Nvidia Performance Primitives-based code
  withNvdec ? withHeadlessDeps && withNvcodec,
  withNvenc ? withHeadlessDeps && withNvcodec,
  withOpenal ? withFullDeps, # OpenAL 1.1 capture support
  withOpenapv ? withHeadlessDeps && lib.versionAtLeast version "8.0", # APV encoding support
  withOpencl ? withHeadlessDeps,
  withOpencoreAmrnb ? withFullDeps && withVersion3, # AMR-NB de/encoder
  withOpencoreAmrwb ? withFullDeps && withVersion3, # AMR-WB decoder
  withOpengl ? withFullDeps && !stdenv.hostPlatform.isDarwin, # OpenGL rendering
  withOpenh264 ? withFullDeps, # H.264/AVC encoder
  withOpenjpeg ? withHeadlessDeps, # JPEG 2000 de/encoder
  withOpenmpt ? withHeadlessDeps, # Tracked music files decoder
  withOpus ? withHeadlessDeps, # Opus de/encoder
  withPlacebo ? withFullDeps && !stdenv.hostPlatform.isDarwin, # libplacebo video processing library
  withPulse ? withSmallDeps && stdenv.hostPlatform.isLinux, # Pulseaudio input support
  withQrencode ? withFullDeps && lib.versionAtLeast version "7", # QR encode generation
  withQuirc ? withFullDeps && lib.versionAtLeast version "7", # QR decoding
  withRav1e ? withFullDeps, # AV1 encoder (focused on speed and safety)
  withRist ? withHeadlessDeps, # Reliable Internet Stream Transport (RIST) protocol
  withRtmp ? false, # RTMP[E] support via librtmp
  withRubberband ? withFullDeps && withGPL && !stdenv.hostPlatform.isFreeBSD, # Rubberband filter
  withSamba ? withFullDeps && !stdenv.hostPlatform.isDarwin && withGPLv3, # Samba protocol
  withSdl2 ? withSmallDeps,
  withShaderc ? withFullDeps && !stdenv.hostPlatform.isDarwin && lib.versionAtLeast version "5.0",
  withShine ? withFullDeps, # Fixed-point MP3 encoding
  withSnappy ? withFullDeps, # Snappy compression, needed for hap encoding
  withSoxr ? withHeadlessDeps, # Resampling via soxr
  withSpeex ? withHeadlessDeps, # Speex de/encoder
  withSrt ? withHeadlessDeps, # Secure Reliable Transport (SRT) protocol
  withSsh ? withHeadlessDeps, # SFTP protocol
  withSvg ? withFullDeps, # SVG protocol
  withSvtav1 ? withHeadlessDeps && !stdenv.hostPlatform.isMinGW, # AV1 encoder/decoder (focused on speed and correctness)
  withTensorflow ? false, # Tensorflow dnn backend support (Increases closure size by ~390 MiB)
  withTheora ? withHeadlessDeps, # Theora encoder
  withTwolame ? withFullDeps, # MP2 encoding
  withUavs3d ? withFullDeps, # AVS3 decoder
  withV4l2 ? withHeadlessDeps && stdenv.hostPlatform.isLinux, # Video 4 Linux support
  withV4l2M2m ? withV4l2,
  withVaapi ? withHeadlessDeps && (with stdenv; isLinux || isFreeBSD), # Vaapi hardware acceleration
  withVdpau ? withSmallDeps && !stdenv.hostPlatform.isMinGW, # Vdpau hardware acceleration
  withVidStab ? withHeadlessDeps && withGPL, # Video stabilization
  withVmaf ? withFullDeps && lib.versionAtLeast version "5", # Netflix's VMAF (Video Multi-Method Assessment Fusion)
  withVoAmrwbenc ? withFullDeps && withVersion3, # AMR-WB encoder
  withVorbis ? withHeadlessDeps, # Vorbis de/encoding, native encoder exists
  withVpl ? withFullDeps && stdenv.hostPlatform.isLinux, # Hardware acceleration via intel libvpl
  withVpx ? withHeadlessDeps && stdenv.buildPlatform == stdenv.hostPlatform, # VP8 & VP9 de/encoding
  withVulkan ? withHeadlessDeps && !stdenv.hostPlatform.isDarwin,
  withVvenc ? withFullDeps && lib.versionAtLeast version "7.1", # H.266/VVC encoding
  withWebp ? withHeadlessDeps, # WebP encoder
  withWhisper ? withFullDeps && lib.versionAtLeast version "8.0", # Whisper speech recognition
  withX264 ? withHeadlessDeps && withGPL, # H.264/AVC encoder
  withX265 ? withHeadlessDeps && withGPL, # H.265/HEVC encoder
  withXavs ? withFullDeps && withGPL, # AVS encoder
  withXavs2 ? withFullDeps && withGPL, # AVS2 encoder
  withXcb ? withXcbShm || withXcbxfixes || withXcbShape, # X11 grabbing using XCB
  withXcbShape ? withFullDeps, # X11 grabbing shape rendering
  withXcbShm ? withFullDeps, # X11 grabbing shm communication
  withXcbxfixes ? withFullDeps, # X11 grabbing mouse rendering
  withXevd ? withFullDeps && lib.versionAtLeast version "7.1" && !xevd.meta.broken, # MPEG-5 EVC decoding
  withXeve ? withFullDeps && lib.versionAtLeast version "7.1" && !xeve.meta.broken, # MPEG-5 EVC encoding
  withXlib ? withFullDeps, # Xlib support
  withXml2 ? withHeadlessDeps, # libxml2 support, for IMF and DASH demuxers
  withXvid ? withHeadlessDeps && withGPL, # Xvid encoder, native encoder exists
  withZimg ? withHeadlessDeps,
  withZlib ? withHeadlessDeps,
  withZmq ? withFullDeps, # Message passing
  withZvbi ? withHeadlessDeps, # Teletext support

  # Licensing options (yes some are listed twice, filters and such are not listed)
  withGPL ? true,
  withVersion3 ? true, # When withGPL is set this implies GPLv3 otherwise it is LGPLv3
  withGPLv3 ? withGPL && withVersion3,
  withUnfree ? false,

  # Build options
  withSmallBuild ? false, # Optimize for size instead of speed
  withRuntimeCPUDetection ? true, # Detect CPU capabilities at runtime (disable to compile natively)
  withGrayscale ? withFullDeps, # Full grayscale support
  withSwscaleAlpha ? buildSwscale, # Alpha channel support in swscale. You probably want this when buildSwscale.
  withHardcodedTables ? withHeadlessDeps, # Hardcode decode tables instead of runtime generation
  withSafeBitstreamReader ? withHeadlessDeps, # Buffer boundary checking in bitreaders
  withMultithread ? true, # Multithreading via pthreads/win32 threads
  withNetwork ? withHeadlessDeps, # Network support
  withPixelutils ? withHeadlessDeps, # Pixel utils in libavutil
  withStatic ? stdenv.hostPlatform.isStatic,
  withShared ? !stdenv.hostPlatform.isStatic,
  withPic ? true,
  withThumb ? false, # On some ARM platforms

  # Program options
  buildFfmpeg ? withHeadlessDeps, # Build ffmpeg executable
  buildFfplay ? withSmallDeps, # Build ffplay executable
  buildFfprobe ? withHeadlessDeps, # Build ffprobe executable
  buildQtFaststart ? withFullDeps, # Build qt-faststart executable
  withBin ? buildFfmpeg || buildFfplay || buildFfprobe || buildQtFaststart,
  # Library options
  buildAvcodec ? withHeadlessDeps, # Build avcodec library
  buildAvdevice ? withHeadlessDeps, # Build avdevice library
  buildAvfilter ? withHeadlessDeps, # Build avfilter library
  buildAvformat ? withHeadlessDeps, # Build avformat library
  # Deprecated but depended upon by some packages.
  # https://github.com/NixOS/nixpkgs/pull/211834#issuecomment-1417435991)
  buildAvresample ? withHeadlessDeps && lib.versionOlder version "5", # Build avresample library
  buildAvutil ? withHeadlessDeps, # Build avutil library
  # Libpostproc is only available on versions lower than 8.0
  # https://code.ffmpeg.org/FFmpeg/FFmpeg/commit/8c920c4c396163e3b9a0b428dd550d3c986236aa
  buildPostproc ? withHeadlessDeps && lib.versionOlder version "8.0", # Build postproc library
  buildSwresample ? withHeadlessDeps, # Build swresample library
  buildSwscale ? withHeadlessDeps, # Build swscale library
  withLib ?
    buildAvcodec
    || buildAvdevice
    || buildAvfilter
    || buildAvformat
    || buildAvutil
    || buildPostproc
    || buildSwresample
    || buildSwscale,
  # Documentation options
  withDocumentation ? withHtmlDoc || withManPages || withPodDoc || withTxtDoc,
  withHtmlDoc ? withHeadlessDeps, # HTML documentation pages
  withManPages ? withHeadlessDeps, # Man documentation pages
  withPodDoc ? withHeadlessDeps, # POD documentation pages
  withTxtDoc ? withHeadlessDeps, # Text documentation pages
  # Whether a "doc" output will be produced. Note that withManPages does not produce
  # a "doc" output because its files go to "man".
  withDoc ? withDocumentation && (withHtmlDoc || withPodDoc || withTxtDoc),

  # Developer options
  withDebug ? false,
  withOptimisations ? true,
  withExtraWarnings ? false,
  withStripping ? false,

  # External libraries options
  alsa-lib,
  amf,
  amf-headers,
  aribb24,
  avisynthplus,
  bzip2,
  celt,
  chromaprint,
  codec2,
  clang,
  dav1d,
  davs2,
  fdk_aac,
  flite,
  fontconfig,
  freetype,
  frei0r,
  fribidi,
  game-music-emu,
  gmp,
  gnutls,
  gsm,
  harfbuzz,
  intel-media-sdk,
  kvazaar,
  ladspaH,
  lame,
  lcevcdec,
  lcms2,
  libaom,
  libaribcaption,
  libass,
  libbluray,
  libbs2b,
  libcaca,
  libcdio,
  libcdio-paranoia,
  libdc1394,
  libdrm,
  libdvdnav,
  libdvdread,
  libGL,
  libGLU,
  libiconv,
  libilbc,
  libjack2,
  libjxl,
  liblc3,
  libmodplug,
  libmysofa,
  libopenmpt,
  libopus,
  libplacebo,
  libplacebo_5,
  libpulseaudio,
  libraw1394,
  librist,
  librsvg,
  libssh,
  libtensorflow,
  libtheora,
  libv4l,
  libva,
  libva-minimal,
  libvdpau,
  libvmaf,
  libvorbis,
  libvpl,
  libvpx,
  libwebp,
  libX11,
  libxcb,
  libXext,
  libxml2,
  libXv,
  nv-codec-headers,
  nv-codec-headers-12,
  ocl-icd, # OpenCL ICD
  openal,
  openapv,
  opencl-headers, # OpenCL headers
  opencore-amr,
  openh264,
  openjpeg,
  qrencode,
  quirc,
  rav1e,
  rtmpdump,
  rubberband,
  twolame,
  samba,
  SDL2,
  shaderc,
  shine,
  snappy,
  soxr,
  speex,
  srt,
  svt-av1,
  uavs3d,
  vid-stab,
  vo-amrwbenc,
  vulkan-headers,
  vulkan-loader,
  vvenc,
  whisper-cpp,
  x264,
  x265,
  xavs,
  xavs2,
  xevd,
  xeve,
  xvidcore,
  xz,
  zeromq,
  zimg,
  zlib,
  zvbi,
  # Darwin
  apple-sdk_15,
  xcode, # unfree contains metalcc and metallib
  # Cuda Packages
  cuda_cudart,
  cuda_nvcc,
  libnpp,
  # Testing
  testers,
}:

/*
  Maintainer notes:

  Version bumps:
  It should always be safe to bump patch releases (e.g. 2.1.x, x being a patch release)
  If adding a new branch, note any configure flags that were added, changed, or deprecated/removed
    and make the necessary changes.

  Known issues:
  Cross-compiling will disable features not present on host OS
    (e.g. dxva2 support [DirectX] will not be enabled unless natively compiled on Cygwin)
*/

let
  inherit (lib)
    optional
    optionals
    optionalString
    enableFeature
    versionOlder
    versionAtLeast
    ;
in

assert lib.elem ffmpegVariant [
  "headless"
  "small"
  "full"
];

# Licensing dependencies
assert withGPLv3 -> withGPL && withVersion3;

# Build dependencies
assert withPixelutils -> buildAvutil;
assert !(withMfx && withVpl); # incompatible features
# Program dependencies
assert
  buildFfmpeg
  -> buildAvcodec && buildAvfilter && buildAvformat && (buildSwresample || buildAvresample);
assert
  buildFfplay
  -> buildAvcodec && buildAvformat && buildSwscale && (buildSwresample || buildAvresample);
assert buildFfprobe -> buildAvcodec && buildAvformat;
# Library dependencies
assert buildAvcodec -> buildAvutil; # configure flag since 0.6
assert buildAvdevice -> buildAvformat && buildAvcodec && buildAvutil; # configure flag since 0.6
assert buildAvformat -> buildAvcodec && buildAvutil; # configure flag since 0.6
assert buildPostproc -> buildAvutil;
assert buildSwscale -> buildAvutil;

# External Library dependencies
assert (withCuda || withCuvid || withNvdec || withNvenc) -> withNvcodec;

stdenv.mkDerivation (
  finalAttrs:
  {
    pname = "ffmpeg" + (optionalString (ffmpegVariant != "small") "-${ffmpegVariant}");
    inherit version;
    src = source;

    postPatch = ''
      patchShebangs .
    ''
    + lib.optionalString withFrei0r ''
      substituteInPlace libavfilter/vf_frei0r.c \
        --replace /usr/local/lib/frei0r-1 ${frei0r}/lib/frei0r-1
      substituteInPlace doc/filters.texi \
        --replace /usr/local/lib/frei0r-1 ${frei0r}/lib/frei0r-1
    '';

    patches =
      [ ]
      ++ optionals (lib.versionOlder version "5") [
        (fetchpatch2 {
          name = "rename_iszero";
          url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/b27ae2c0b704e83f950980102bc3f12f9ec17cb0";
          hash = "sha256-l1t4LcUDSW757diNu69NzvjenW5Mxb5aYtXz64Yl9gs=";
        })
      ]
      ++ optionals (lib.versionAtLeast version "5.1") [
        ./nvccflags-cpp14.patch
      ]
      ++ optionals (lib.versionAtLeast version "6.1" && lib.versionOlder version "6.2") [
        (fetchpatch2 {
          # this can be removed post 6.1
          name = "fix_build_failure_due_to_PropertyKey_EncoderID";
          url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/cb049d377f54f6b747667a93e4b719380c3e9475";
          hash = "sha256-sxRXKKgUak5vsQTiV7ge8vp+N22CdTIvuczNgVRP72c=";
        })
        (fetchpatch2 {
          name = "CVE-2024-31582.patch";
          url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/99debe5f823f45a482e1dc08de35879aa9c74bd2";
          hash = "sha256-+CQ9FXR6Vr/AmsbXFiCUXZcxKj1s8nInEdke/Oc/kUA=";
        })
        (fetchpatch2 {
          name = "CVE-2024-31578.patch";
          url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/3bb00c0a420c3ce83c6fafee30270d69622ccad7";
          hash = "sha256-oZMZysBA+/gwaGEM1yvI+8wCadXWE7qLRL6Emap3b8Q=";
        })
        (fetchpatch2 {
          name = "CVE-2023-49501.patch";
          url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/4adb93dff05dd947878c67784d98c9a4e13b57a7";
          hash = "sha256-7cwktto3fPMDGvCZCVtB01X8Q9S/4V4bDLUICSNfGgw=";
        })
        (fetchpatch2 {
          name = "CVE-2023-49502.patch";
          url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/737ede405b11a37fdd61d19cf25df296a0cb0b75";
          hash = "sha256-mpSJwR9TX5ENjjCKvzuM/9e1Aj/AOiQW0+72oOMl9v8=";
        })
        (fetchpatch2 {
          name = "CVE-2023-50007.patch";
          url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/b1942734c7cbcdc9034034373abcc9ecb9644c47";
          hash = "sha256-v0hNcqBtm8GCGAU9UbRUCE0slodOjZCHrkS8e4TrVcQ=";
        })
        (fetchpatch2 {
          name = "CVE-2023-50008.patch";
          url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/5f87a68cf70dafeab2fb89b42e41a4c29053b89b";
          hash = "sha256-sqUUSOPTPLwu2h8GbAw4SfEf+0oWioz52BcpW1n4v3Y=";
        })
      ]
      ++ optionals (lib.versionOlder version "7.1.1") [
        (fetchpatch2 {
          name = "texinfo-7.1.patch";
          url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/4d9cdf82ee36a7da4f065821c86165fe565aeac2";
          hash = "sha256-BZsq1WI6OgtkCQE8koQu0CNcb5c8WgTu/LzQzu6ZLuo=";
        })
      ]
      ++ optionals (lib.versionOlder version "7" && stdenv.hostPlatform.isAarch32) [
        (fetchpatch2 {
          name = "binutils-2-43-compat.patch";
          url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/654bd47716c4f36719fb0f3f7fd8386d5ed0b916";
          hash = "sha256-OLiQHKBNp2p63ZmzBBI4GEGz3WSSP+rMd8ITfZSVRgY=";
        })
      ]
      ++ optionals (lib.versionAtLeast version "7.1" && lib.versionOlder version "7.1.1") [
        ./fix-fate-ffmpeg-spec-disposition-7.1.patch
      ]
      ++ optionals (lib.versionAtLeast version "7.1.1") [
        # Expose a private API for Chromium / Qt WebEngine.
        (fetchpatch2 {
          url = "https://gitlab.archlinux.org/archlinux/packaging/packages/ffmpeg/-/raw/a02c1a15706ea832c0d52a4d66be8fb29499801a/add-av_stream_get_first_dts-for-chromium.patch";
          hash = "sha256-DbH6ieJwDwTjKOdQ04xvRcSLeeLP2Z2qEmqeo8HsPr4=";
        })
        (fetchpatch2 {
          name = "lcevcdec-4.0.0-compat.patch";
          url = "https://code.ffmpeg.org/FFmpeg/FFmpeg/commit/fa23202cc7baab899894e8d22d82851a84967848.patch";
          hash = "sha256-Ixkf1xzuDGk5t8J/apXKtghY0X9cfqSj/q987zrUuLQ=";
        })
      ]
      ++ optionals (lib.versionOlder version "7.2") [
        (fetchpatch2 {
          name = "unbreak-svt-av1-3.0.0.patch";
          url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/d1ed5c06e3edc5f2b5f3664c80121fa55b0baa95";
          hash = "sha256-2NVkIhQVS1UQJVYuDdeH+ZvWYKVbtwW9Myu5gx7JnbA=";
        })
      ];

    configurePlatforms = [ ];
    setOutputFlags = false; # Only accepts some of them
    configureFlags = [
      #mingw64 is internally treated as mingw32, so 32 and 64 make no difference here
      "--target_os=${
        if stdenv.hostPlatform.isMinGW then "mingw64" else stdenv.hostPlatform.parsed.kernel.name
      }"
      "--arch=${stdenv.hostPlatform.parsed.cpu.name}"
      "--pkg-config=${buildPackages.pkg-config.targetPrefix}pkg-config"
      # Licensing flags
      (enableFeature withGPL "gpl")
      (enableFeature withVersion3 "version3")
      (enableFeature withUnfree "nonfree")
      # Build flags
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

      # Program flags
      (enableFeature buildFfmpeg "ffmpeg")
      (enableFeature buildFfplay "ffplay")
      (enableFeature buildFfprobe "ffprobe")
    ]
    ++ optionals withBin [
      "--bindir=${placeholder "bin"}/bin"
    ]
    ++ [
      # Library flags
      (enableFeature buildAvcodec "avcodec")
      (enableFeature buildAvdevice "avdevice")
      (enableFeature buildAvfilter "avfilter")
      (enableFeature buildAvformat "avformat")
    ]
    ++ optionals (lib.versionOlder version "5") [
      # Ffmpeg > 4 doesn't know about the flag anymore
      (enableFeature buildAvresample "avresample")
    ]
    ++ [
      (enableFeature buildAvutil "avutil")
    ]
    ++ optionals (lib.versionOlder version "8.0") [
      # FFMpeg >= 8 doesn't know about the flag anymore
      (enableFeature (buildPostproc && withGPL) "postproc")
    ]
    ++ [
      (enableFeature buildSwresample "swresample")
      (enableFeature buildSwscale "swscale")
    ]
    ++ optionals withLib [
      "--libdir=${placeholder "lib"}/lib"
      "--incdir=${placeholder "dev"}/include"
    ]
    ++ [
      # Documentation flags
      (enableFeature withDocumentation "doc")
      (enableFeature withHtmlDoc "htmlpages")
      (enableFeature withManPages "manpages")
    ]
    ++ optionals withManPages [
      "--mandir=${placeholder "man"}/share/man"
    ]
    ++ [
      (enableFeature withPodDoc "podpages")
      (enableFeature withTxtDoc "txtpages")
    ]
    ++ optionals withDoc [
      "--docdir=${placeholder "doc"}/share/doc/ffmpeg"
    ]
    ++ [
      # External libraries
      (enableFeature withAlsa "alsa")
      (enableFeature withAmf "amf")
      (enableFeature withAom "libaom")
      (enableFeature withAribb24 "libaribb24")
    ]
    ++ optionals (versionAtLeast version "6.1") [
      (enableFeature withAribcaption "libaribcaption")
    ]
    ++ [
      (enableFeature withAss "libass")
      (enableFeature withAvisynth "avisynth")
      (enableFeature withBluray "libbluray")
      (enableFeature withBs2b "libbs2b")
      (enableFeature withBzlib "bzlib")
      (enableFeature withCaca "libcaca")
      (enableFeature withCdio "libcdio")
      (enableFeature withCelt "libcelt")
      (enableFeature withChromaprint "chromaprint")
      (enableFeature withCodec2 "libcodec2")
      (enableFeature withCuda "cuda")
      (enableFeature withCudaLLVM "cuda-llvm")
      (enableFeature withCudaNVCC "cuda-nvcc")
      (enableFeature withCuvid "cuvid")
      (enableFeature withDav1d "libdav1d")
      (enableFeature withDavs2 "libdavs2")
      (enableFeature withDc1394 "libdc1394")
      (enableFeature withDrm "libdrm")
    ]
    ++ optionals (versionAtLeast version "7") [
      (enableFeature withDvdnav "libdvdnav")
      (enableFeature withDvdread "libdvdread")
    ]
    ++ [
      (enableFeature withFdkAac "libfdk-aac")
      (enableFeature withNvcodec "ffnvcodec")
      (enableFeature withFlite "libflite")
      (enableFeature withFontconfig "fontconfig")
      (enableFeature withFontconfig "libfontconfig")
      (enableFeature withFreetype "libfreetype")
      (enableFeature withFrei0r "frei0r")
      (enableFeature withFribidi "libfribidi")
      (enableFeature withGme "libgme")
      (enableFeature withGmp "gmp")
      (enableFeature withGnutls "gnutls")
      (enableFeature withGsm "libgsm")
    ]
    ++ optionals (versionAtLeast version "6.1") [
      (enableFeature withHarfbuzz "libharfbuzz")
    ]
    ++ [
      (enableFeature withIconv "iconv")
      (enableFeature withIlbc "libilbc")
      (enableFeature withJack "libjack")
    ]
    ++ optionals (versionAtLeast finalAttrs.version "5.0") [
      (enableFeature withJxl "libjxl")
    ]
    ++ [
      (enableFeature withKvazaar "libkvazaar")
      (enableFeature withLadspa "ladspa")
    ]
    ++ optionals (versionAtLeast version "7.1") [
      (enableFeature withLc3 "liblc3")
      (enableFeature withLcevcdec "liblcevc-dec")
    ]
    ++ optionals (versionAtLeast version "5.1") [
      (enableFeature withLcms2 "lcms2")
    ]
    ++ [
      (enableFeature withLzma "lzma")
    ]
    ++ optionals (versionAtLeast version "5.0") [
      (enableFeature withMetal "metal")
    ]
    ++ [
      (enableFeature withMfx "libmfx")
      (enableFeature withModplug "libmodplug")
      (enableFeature withMp3lame "libmp3lame")
      (enableFeature withMysofa "libmysofa")
      (enableFeature withNpp "libnpp")
      (enableFeature withNvdec "nvdec")
      (enableFeature withNvenc "nvenc")
      (enableFeature withOpenal "openal")
    ]
    ++ optionals (versionAtLeast version "8.0") [
      (enableFeature withOpenapv "liboapv")
    ]
    ++ [
      (enableFeature withOpencl "opencl")
      (enableFeature withOpencoreAmrnb "libopencore-amrnb")
      (enableFeature withOpencoreAmrwb "libopencore-amrwb")
      (enableFeature withOpengl "opengl")
      (enableFeature withOpenh264 "libopenh264")
      (enableFeature withOpenjpeg "libopenjpeg")
      (enableFeature withOpenmpt "libopenmpt")
      (enableFeature withOpus "libopus")
    ]
    ++ optionals (versionAtLeast version "5.0") [
      (enableFeature withPlacebo "libplacebo")
    ]
    ++ [
      (enableFeature withPulse "libpulse")
    ]
    ++ optionals (versionAtLeast version "7") [
      (enableFeature withQrencode "libqrencode")
      (enableFeature withQuirc "libquirc")
    ]
    ++ [
      (enableFeature withRav1e "librav1e")
      (enableFeature withRist "librist")
      (enableFeature withRtmp "librtmp")
      (enableFeature withRubberband "librubberband")
      (enableFeature withSamba "libsmbclient")
      (enableFeature withSdl2 "sdl2")
    ]
    ++ optionals (versionAtLeast version "5.0") [
      (enableFeature withShaderc "libshaderc")
    ]
    ++ [
      (enableFeature withShine "libshine")
      (enableFeature withSnappy "libsnappy")
      (enableFeature withSoxr "libsoxr")
      (enableFeature withSpeex "libspeex")
      (enableFeature withSrt "libsrt")
      (enableFeature withSsh "libssh")
      (enableFeature withSvg "librsvg")
      (enableFeature withSvtav1 "libsvtav1")
      (enableFeature withTensorflow "libtensorflow")
      (enableFeature withTheora "libtheora")
      (enableFeature withTwolame "libtwolame")
      (enableFeature withUavs3d "libuavs3d")
      (enableFeature withV4l2 "libv4l2")
      (enableFeature withV4l2M2m "v4l2-m2m")
      (enableFeature withVaapi "vaapi")
      (enableFeature withVdpau "vdpau")
    ]
    ++ optionals (versionAtLeast version "6.0") [
      (enableFeature withVpl "libvpl")
    ]
    ++ [
      (enableFeature withVidStab "libvidstab") # Actual min. version 2.0
      (enableFeature withVmaf "libvmaf")
      (enableFeature withVoAmrwbenc "libvo-amrwbenc")
      (enableFeature withVorbis "libvorbis")
      (enableFeature withVpx "libvpx")
      (enableFeature withVulkan "vulkan")
    ]
    ++ optionals (versionAtLeast version "7.1") [
      (enableFeature withVvenc "libvvenc")
    ]
    ++ [
      (enableFeature withWebp "libwebp")
    ]
    ++ optionals (versionAtLeast version "8.0") [
      (enableFeature withWhisper "whisper")
    ]
    ++ [
      (enableFeature withX264 "libx264")
      (enableFeature withX265 "libx265")
      (enableFeature withXavs "libxavs")
      (enableFeature withXavs2 "libxavs2")
      (enableFeature withXcb "libxcb")
      (enableFeature withXcbShape "libxcb-shape")
      (enableFeature withXcbShm "libxcb-shm")
      (enableFeature withXcbxfixes "libxcb-xfixes")
    ]
    ++ optionals (versionAtLeast version "7") [
      (enableFeature withXevd "libxevd")
      (enableFeature withXeve "libxeve")
    ]
    ++ [
      (enableFeature withXlib "xlib")
      (enableFeature withXml2 "libxml2")
      (enableFeature withXvid "libxvid")
      (enableFeature withZimg "libzimg")
      (enableFeature withZlib "zlib")
      (enableFeature withZmq "libzmq")
      (enableFeature withZvbi "libzvbi")
      # Developer flags
      (enableFeature withDebug "debug")
      (enableFeature withOptimisations "optimizations")
      (enableFeature withExtraWarnings "extra-warnings")
      (enableFeature withStripping "stripping")
    ]
    ++ optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      "--cross-prefix=${stdenv.cc.targetPrefix}"
      "--enable-cross-compile"
      "--host-cc=${buildPackages.stdenv.cc}/bin/cc"
    ]
    ++ optionals stdenv.cc.isClang [
      "--cc=${stdenv.cc.targetPrefix}clang"
      "--cxx=${stdenv.cc.targetPrefix}clang++"
    ]
    ++ optionals withMetal [
      "--metalcc=${xcode}/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/metal"
      "--metallib=${xcode}/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/metallib"
    ];

    # ffmpeg embeds the configureFlags verbatim in its binaries and because we
    # configure binary, include, library dir etc., this causes references in
    # outputs where we don't want them. Patch the generated config.h to remove all
    # such references except for data.
    postConfigure =
      let
        toStrip =
          map placeholder (lib.remove "data" finalAttrs.outputs) # We want to keep references to the data dir.
          ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) buildPackages.stdenv.cc
          ++ lib.optional withMetal xcode;
      in
      "remove-references-to ${lib.concatStringsSep " " (map (o: "-t ${o}") toStrip)} config.h";

    strictDeps = true;

    nativeBuildInputs = [
      removeReferencesTo
      addDriverRunpath
      perl
      pkg-config
    ]
    # 8.0 is only compatible with nasm, and we don't want to rebuild all older ffmpeg builds at this moment.
    ++ (if versionOlder version "8.0" then [ yasm ] else [ nasm ])
    # Texinfo version 7.1 introduced breaking changes, which older versions of ffmpeg do not handle.
    ++ (if versionOlder version "5" then [ texinfo6 ] else [ texinfo ])
    ++ optionals withCudaLLVM [ clang ]
    ++ optionals withCudaNVCC [ cuda_nvcc ];

    buildInputs =
      [ ]
      ++ optionals stdenv.hostPlatform.isDarwin [ apple-sdk_15 ]
      ++ optionals withAlsa [ alsa-lib ]
      ++ optionals withAmf [ amf-headers ]
      ++ optionals withAom [ libaom ]
      ++ optionals withAribb24 [ aribb24 ]
      ++ optionals withAribcaption [ libaribcaption ]
      ++ optionals withAss [ libass ]
      ++ optionals withAvisynth [ avisynthplus ]
      ++ optionals withBluray [ libbluray ]
      ++ optionals withBs2b [ libbs2b ]
      ++ optionals withBzlib [ bzip2 ]
      ++ optionals withCaca [ libcaca ]
      ++ optionals withCdio [
        libcdio
        libcdio-paranoia
      ]
      ++ optionals withCelt [ celt ]
      ++ optionals withChromaprint [ chromaprint ]
      ++ optionals withCodec2 [ codec2 ]
      ++ optionals withCudaNVCC [
        cuda_cudart
        cuda_nvcc
      ]
      ++ optionals withDav1d [ dav1d ]
      ++ optionals withDavs2 [ davs2 ]
      ++ optionals withDc1394 ([ libdc1394 ] ++ (lib.optional stdenv.hostPlatform.isLinux libraw1394))
      ++ optionals withDrm [ libdrm ]
      ++ optionals withDvdnav [ libdvdnav ]
      ++ optionals withDvdread [ libdvdread ]
      ++ optionals withFdkAac [ fdk_aac ]
      ++ optionals withNvcodec [
        (if (lib.versionAtLeast version "6") then nv-codec-headers-12 else nv-codec-headers)
      ]
      ++ optionals withFlite [ flite ]
      ++ optionals withFontconfig [ fontconfig ]
      ++ optionals withFreetype [ freetype ]
      ++ optionals withFrei0r [ frei0r ]
      ++ optionals withFribidi [ fribidi ]
      ++ optionals withGme [ game-music-emu ]
      ++ optionals withGmp [ gmp ]
      ++ optionals withGnutls [ gnutls ]
      ++ optionals withGsm [ gsm ]
      ++ optionals withHarfbuzz [ harfbuzz ]
      ++ optionals withIconv [ libiconv ] # On Linux this should be in libc, do we really need it?
      ++ optionals withIlbc [ libilbc ]
      ++ optionals withJack [ libjack2 ]
      ++ optionals withJxl [ libjxl ]
      ++ optionals withKvazaar [ kvazaar ]
      ++ optionals withLadspa [ ladspaH ]
      ++ optionals withLc3 [ liblc3 ]
      ++ optionals withLcevcdec [ lcevcdec ]
      ++ optionals withLcms2 [ lcms2 ]
      ++ optionals withLzma [ xz ]
      ++ optionals withMfx [ intel-media-sdk ]
      ++ optionals withModplug [ libmodplug ]
      ++ optionals withMp3lame [ lame ]
      ++ optionals withMysofa [ libmysofa ]
      ++ optionals withNpp [
        libnpp
        cuda_cudart
        cuda_nvcc
      ]
      ++ optionals withOpenal [ openal ]
      ++ optionals withOpenapv [ openapv ]
      ++ optionals withOpencl [
        ocl-icd
        opencl-headers
      ]
      ++ optionals (withOpencoreAmrnb || withOpencoreAmrwb) [ opencore-amr ]
      ++ optionals withOpengl [
        libGL
        libGLU
      ]
      ++ optionals withOpenh264 [ openh264 ]
      ++ optionals withOpenjpeg [ openjpeg ]
      ++ optionals withOpenmpt [ libopenmpt ]
      ++ optionals withOpus [ libopus ]
      ++ optionals withPlacebo [
        (if (lib.versionAtLeast version "6.1") then libplacebo else libplacebo_5)
        vulkan-headers
      ]
      ++ optionals withPulse [ libpulseaudio ]
      ++ optionals withQrencode [ qrencode ]
      ++ optionals withQuirc [ quirc ]
      ++ optionals withRav1e [ rav1e ]
      ++ optionals withRist [ librist ]
      ++ optionals withRtmp [ rtmpdump ]
      ++ optionals withRubberband [ rubberband ]
      ++ optionals withSamba [ samba ]
      ++ optionals withSdl2 [ SDL2 ]
      ++ optionals withShaderc [ shaderc ]
      ++ optionals withShine [ shine ]
      ++ optionals withSnappy [ snappy ]
      ++ optionals withSoxr [ soxr ]
      ++ optionals withSpeex [ speex ]
      ++ optionals withSrt [ srt ]
      ++ optionals withSsh [ libssh ]
      ++ optionals withSvg [ librsvg ]
      ++ optionals withSvtav1 [ svt-av1 ]
      ++ optionals withTensorflow [ libtensorflow ]
      ++ optionals withTheora [ libtheora ]
      ++ optionals withTwolame [ twolame ]
      ++ optionals withUavs3d [ uavs3d ]
      ++ optionals withV4l2 [ libv4l ]
      ++ optionals withVaapi [ (if withSmallDeps then libva else libva-minimal) ]
      ++ optionals withVdpau [ libvdpau ]
      ++ optionals withVidStab [ vid-stab ]
      ++ optionals withVmaf [ libvmaf ]
      ++ optionals withVoAmrwbenc [ vo-amrwbenc ]
      ++ optionals withVorbis [ libvorbis ]
      ++ optionals withVpl [ libvpl ]
      ++ optionals withVpx [ libvpx ]
      ++ optionals withVulkan [
        vulkan-headers
        vulkan-loader
      ]
      ++ optionals withVvenc [ vvenc ]
      ++ optionals withWebp [ libwebp ]
      ++ optionals withWhisper [ whisper-cpp ]
      ++ optionals withX264 [ x264 ]
      ++ optionals withX265 [ x265 ]
      ++ optionals withXavs [ xavs ]
      ++ optionals withXavs2 [ xavs2 ]
      ++ optionals withXcb [ libxcb ]
      ++ optionals withXevd [ xevd ]
      ++ optionals withXeve [ xeve ]
      ++ optionals withXlib [
        libX11
        libXv
        libXext
      ]
      ++ optionals withXml2 [ libxml2 ]
      ++ optionals withXvid [ xvidcore ]
      ++ optionals withZimg [ zimg ]
      ++ optionals withZlib [ zlib ]
      ++ optionals withZmq [ zeromq ]
      ++ optionals withZvbi [ zvbi ];

    buildFlags = [ "all" ] ++ optional buildQtFaststart "tools/qt-faststart"; # Build qt-faststart executable

    env = lib.optionalAttrs stdenv.cc.isGNU {
      NIX_CFLAGS_COMPILE = toString [
        "-Wno-error=incompatible-pointer-types"
        "-Wno-error=int-conversion"
      ];
    };

    doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

    # Fails with SIGABRT otherwise FIXME: Why?
    checkPhase =
      let
        ldLibraryPathEnv = if stdenv.hostPlatform.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
        libsToLink =
          [ ]
          ++ optional buildAvcodec "libavcodec"
          ++ optional buildAvdevice "libavdevice"
          ++ optional buildAvfilter "libavfilter"
          ++ optional buildAvformat "libavformat"
          ++ optional buildAvresample "libavresample"
          ++ optional buildAvutil "libavutil"
          ++ optional buildPostproc "libpostproc"
          ++ optional buildSwresample "libswresample"
          ++ optional buildSwscale "libswscale";
      in
      ''
        ${ldLibraryPathEnv}="${lib.concatStringsSep ":" libsToLink}" make check -j$NIX_BUILD_CORES
      '';

    outputs =
      optionals withBin [ "bin" ] # The first output is the one that gets symlinked by default!
      ++ optionals withLib [
        "lib"
        "dev"
      ]
      ++ optionals withDoc [ "doc" ]
      ++ optionals withManPages [ "man" ]
      ++ [
        "data"
        "out"
      ] # We need an "out" output because we get an error otherwise. It's just an empty dir.
    ;

    postInstall = optionalString buildQtFaststart ''
      install -D tools/qt-faststart -t $bin/bin
    '';

    # Set RUNPATH so that libnvcuvid and libcuda in /run/opengl-driver(-32)/lib can be found.
    # See the explanation in addDriverRunpath.
    postFixup =
      optionalString (stdenv.hostPlatform.isLinux && withLib) ''
        addDriverRunpath ${placeholder "lib"}/lib/libavcodec.so
        addDriverRunpath ${placeholder "lib"}/lib/libavutil.so
      ''
      # https://trac.ffmpeg.org/ticket/10809
      + optionalString (versionAtLeast version "5.0" && withVulkan && !stdenv.hostPlatform.isMinGW) ''
        patchelf $lib/lib/libavcodec.so --add-needed libvulkan.so --add-rpath ${
          lib.makeLibraryPath [ vulkan-loader ]
        }
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
      license =
        with licenses;
        [ lgpl21Plus ]
        ++ optional withGPL gpl2Plus
        ++ optional withVersion3 lgpl3Plus
        ++ optional withGPLv3 gpl3Plus
        ++ optional withUnfree unfreeRedistributable
        ++ optional (withGPL && withUnfree) unfree;
      pkgConfigModules =
        [ ]
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
      maintainers = with maintainers; [
        atemu
        jopejoe1
        emily
      ];
      mainProgram = "ffmpeg";
    };
  }
  // lib.optionalAttrs withCudaLLVM {
    # remove once https://github.com/NixOS/nixpkgs/issues/318674 is addressed properly
    hardeningDisable = [
      "pacret"
      "shadowstack"
      "zerocallusedregs"
    ];
  }
)
