{
  lib,
  config,
  stdenv,
  pkgs, # TODO
  version,
  variant,
  variants,
  ...
}:


let
  # Checks whether the given variant of the flag is contained in the currently
  # active variant. full ⊃ small ⊃ headless
  isInVariant = flagVariant:
    let
      checks = {
        full = variant == variants.full;
        small = variant == variants.small || checks.full;
        headless = variant == variants.headless || checks.small;
      };
    in checks.${flagVariant} or false;
  ffmpegFlag = lib.types.submodule ({ config, name, ... }: {
    options = {
      enable = lib.mkEnableOption "Whether to enable ${name} support in ffmpeg." // lib.mkOption {
        # TODO this works but doesn't allow for convenient overrides yet. You
        # can easily override enable = true but it will still be gated behind
        # the variant check.
        default = isInVariant config.variant && config.gate;
      };
      packages = lib.mkOption {
        type = with lib.types; attrsOf package;
        default = { };
        description = "The dependencies required to enable ${name} support.";
      };
      version = lib.mkOption {
        type = lib.types.str;
        default = "0"; # Unknown/Enable in any version
        description = "Minimum version that understands this flag. Flag will not be passed when lower.";
      };
      versionMax = lib.mkOption {
        type = lib.types.str;
        default = "99999999"; # Unknown/Enable in any version
        description = "Maximum version that understands this flag. Flag will not be passed when higher.";
      };
      variant = lib.mkOption {
        type = lib.types.enum [ "headless" "small" "full" ];
        default = "headless";
        description = ''
          Which variant this feature should be enabled in.

          Headless: Build with dependency set that is necessary for headless
          operation; excludes dependencies that are only necessary for GUI
          applications. Intended for purposes that don't generally need such
          components and i.e. only depend on libav and for bootstrapping.

          Small: Dependencies a user might customarily expect from a regular
          ffmpeg build. /All/ packages that depend on ffmpeg and some of its
          feaures should depend on the small variant. Small means the minimal
          set of features that satisfies all dependants in Nixpkgs

          Full: All dependencies enabled; only guarded behind platform
          exclusivity, brokeness or extreme closure sizes that make more sense
          in a specific ffmpeg variant. If you need to depend on ffmpeg-full
          because ffmpeg is missing some feature your package needs, you should
          enable that feature in regular ffmpeg instead.
        '';
      };

      gate = lib.mkOption {
        default = true;
        description = ''
          Gates the default value for {option}`enable` behind a boolean. Use
          this to disable certain features on certain platforms by default.
        '';
      };

      flags = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ (config.flagPrefix + name) ];
        description = ''
          Flags to be passed to the configure script for this feature.
        '';
      };

      flagPrefix = lib.mkOption {
        default = "";
        example = "lib";
        description = ''
          Which prefix the configure enable flag has. Frequently `lib`.
        '';
      };

      description = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        readOnly = true;
      };
    };
  });

  mkFfmpegOption = name: default: lib.mkOption {
    type = ffmpegFlag;
    inherit default; # Default done via ffmpegFlag type
    description =
      let
        hasDescription = default.description or null != null;
        additionalDescription = lib.optionalString hasDescription ": ${default.description}";
      in
        "Control ${name} support in ffmpeg${additionalDescription}.";
  };

  inherit (variants) headless small full;

  featureOptions = config:
    # FIXME
    with pkgs;
    with pkgs.darwin.apple_sdk.frameworks;
    with pkgs.xorg;
    let
      enable = lib.mapAttrs (n: v: v.enable) config;
    in
    {
    /*
     *  Licensing flags
     */
    gpl = { };
    version3 = {
      description = "When {option}`gpl` is set this implies {option}`gplv3`. Otherwise the license is LGPLv3";
    };
    gplv3 = {
      gate = enable.gpl && enable.version3;
      flags = [ ]; # internal
    };
    unfree = {
      enable = false;
      flags = [ "nonfree" ];
    };
    /*
      *  Build flags
      */
    static = { gate = stdenv.hostPlatform.isStatic; };
    shared = { gate = !stdenv.hostPlatform.isStatic; };
    pic = { };
    thumb = { enable = false; };
    small = { enable = false; };
    runtime-cpudetect = { };
    gray = { variant = full; };
    swscale-alpha = { }; # TODO same as swscale?
    hardcoded-tables = { };
    safe-bitstream-reader = { };

    small = { };
    runtime-cpudetect = { };
    gray = { };
    swscale-alpha = { };
    hardcoded-tables = { };
    safe-bitstream-reader = { };

    multithread = { flags = [ ]; };
    pthreads = {
      gate = enable.multithread && stdenv.hostPlatform.isUnix;
    };
    w32threads = {
      gate = enable.multithread && stdenv.hostPlatform.isWindows;
    };
    os2threads = {
      # We don't support OS/2
      enable = false;
    };

    network = { };
    pixelutils = { };

    /*
      *  Program flags
      */
    ffmpeg = { };
    ffplay = { variant = small; };
    ffprobe = { };

    /*
      *  Library flags
      */
    avcodec = { };
    avdevice = { };
    avfilter = { };
    avformat = { };
    avresample = {
      # Ffmpeg > 4 doesn't know about the flag anymore
      versionMax = "5";
    };

    avutil = { };
    postproc = { gate = enable.gpl; };
    swresample = { };
    swscale = { };

    /*
      *  Documentation flags
      */
    doc = { };
    htmlpages = { };
    manpages = { };
    podpages = { };
    txtpages = { };

    /*
      * Developer flags
      */
    debug = { enable = false; };
    optimizations = { };
    extra-warnings = { enable = false; };
    stripping = { enable = false; };

    # Feature flags
    alsa = { packages = { inherit alsa-lib; }; };
    aom = {
      variant = full;
      packages = { inherit libaom; };
      flagPrefix = "lib";
      description = "AV1 reference encoder";
    };
    appkit = {
      gate = stdenv.isDarwin;
      packages = { inherit AppKit; };
    };
    aribcaption = {
      variant = full;
      packages = { inherit libaribcaption; };
      flagPrefix = "lib";
      description = "ARIB STD-B24 Caption Decoder/Renderer";
    };
    ass = {
      gate = stdenv.hostPlatform == stdenv.buildPlatform;
      packages = { inherit libass; };
      flagPrefix = "lib";
      description = "(Advanced) SubStation Alpha subtitle rendering";
    };
    audiotoolbox = {
      gate = stdenv.isDarwin;
      packages = { inherit AudioToolbox; };
    };
    avfoundation = {
      gate = stdenv.isDarwin;
      packages = { inherit AVFoundation; };
    };
    avisynth = {
      variant = full;
      packages = { inherit avisynthplus; };
      description = "AviSynth script processing";
    };
    bluray = {
      variant = full;
      packages = { inherit libbluray; };
      flagPrefix = "lib";
    };
    bs2b = {
      variant = full;
      packages = { inherit libbs2b; };
      flagPrefix = "lib";
    };
    bzlib = { packages = { inherit bzip2; }; };
    caca = {
      variant = full;
      packages = { inherit libcaca; };
      flagPrefix = "lib";
      description = "Textual display (ASCII art)";
    };
    celt = {
      variant = full;
      packages = { inherit celt; };
      flagPrefix = "lib";
    };
    chromaprint = {
      variant = full;
      packages = { inherit chromaprint; };
      description = "Audio fingerprinting";
    };
    codec2 = {
      variant = full;
      packages = { inherit codec2; };
      flagPrefix = "lib";
    };
    coreimage = {
      gate = stdenv.isDarwin;
      packages = { inherit CoreImage; };
    };
    cuda = {
      inherit (config.nvcodec) gate;
      variant = full;
    };
    cuda-llvm = {
      variant = full;
    };
    cuvid = {
      inherit (config.nvcodec) gate;
    };
    dav1d = {
      packages = { inherit dav1d; };
      flagPrefix = "lib";
      description = "AV1 decoder (focused on speed and correctness)";
    };
    dc1394 = {
      gate = !stdenv.isDarwin;
      variant = full;
      packages = { inherit libdc1394 libraw1394; };
      flagPrefix = "lib";
      description = "IIDC-1394 grabbing (ieee 1394/Firewire)";
    };
    drm = {
      gate = with stdenv; isLinux || isFreeBSD;
      packages = { inherit libdrm; };
      flagPrefix = "lib";
    };
    dvdnav = {
      gate = enable.gpl;
      variant = full;
      version = "7";
      packages = { inherit libdvdnav; };
      flagPrefix = "lib";
      description = "DVD demuxing";
    };
    dvdread = {
      gate = enable.gpl;
      variant = full;
      version = "7";
      packages = { inherit libdvdread; };
      flagPrefix = "lib";
      description = "DVD demuxing";
    };
    fdk-aac = {
      gate = with enable; !gpl || unfree;
      variant = full;
      packages = { inherit fdk_aac; };
      flagPrefix = "lib";
      description = "Fraunhofer FDK AAC de/encoder";
    };
    nvcodec = {
      gate = with stdenv; !isDarwin && !isAarch32 && !hostPlatform.isRiscV && hostPlatform == buildPlatform;
      packages = {
        nv-codec-headers =
          if lib.versionAtLeast version "6"
          then nv-codec-headers-12
          else nv-codec-headers;
      };
      flagPrefix = "ff";
      description = "Dynamically linked Nvidia code";
    };
    flite = {
      variant = full;
      packages = { inherit flite; };
      flagPrefix = "lib";
      description = "Voice synthesis";
    };
    fontconfig = {
      packages = { inherit fontconfig; };
      flags = [ "fontconfig" "libfontconfig" ];
      description = "Font support for i.e. the drawtext filter";
    };
    freetype = {
      packages = { inherit freetype; };
      flagPrefix = "lib";
      description = "Font support for i.e. the drawtext filter";
    };
    frei0r = {
      gate = enable.gpl;
      variant = full;
      packages = { inherit frei0r; };
      description = "Frei0r video filtering";
    };
    fribidi = {
      variant = full;
      packages = { inherit fribidi; };
      flagPrefix = "lib";
      description = "Font support for i.e. the drawtext filter";
    };
    gme = {
      variant = full;
      packages = { inherit game-music-emu; };
      flagPrefix = "lib";
      description = "Game Music Emulator";
    };
    gnutls = { packages = { inherit gnutls; }; };
    gsm = {
      variant = full;
      packages = { inherit gsm; };
      flagPrefix = "lib";
    };
    harfbuzz = {
      version = "6.1";
      packages = { inherit harfbuzz; };
      flagPrefix = "lib";
      description = "Font support for i.e. the drawtext filter";
    };
    iconv = { packages = { inherit libiconv; }; }; # On Linux this should be in libc, do we really need it?
    jack = {
      gate = !stdenv.isDarwin;
      variant = full;
      packages = { inherit libjack2; };
      flagPrefix = "lib";
    };
    jxl = {
      variant = full;
      version = "5";
      packages = { inherit libjxl; };
      flagPrefix = "lib";
    };
    ladspa = {
      variant = full;
      packages = { inherit ladspaH; };
      description = "LADSPA audio filtering";
    };
    lzma = { packages = { inherit xz; }; };
    mfx = {
      gate = with stdenv.hostPlatform; isLinux && !isAarch;
      variant = full;
      packages = { inherit intel-media-sdk; };
      flagPrefix = "lib";
      description = "Hardware acceleration via intel-media-sdk/libmfx (incompatible with {option}`vpl`)";
    };
    modplug = {
      gate = !stdenv.isDarwin;
      variant = full;
      packages = { inherit libmodplug; };
      flagPrefix = "lib";
    };
    mp3lame = {
      packages = { inherit lame; };
      flagPrefix = "lib";
    };
    mysofa = {
      variant = full;
      packages = { inherit libmysofa; };
      flagPrefix = "lib";
      description = "HRTF support via SOFAlizer";
    };
    nvdec = {
      inherit (config.nvcodec) gate;
    };
    nvenc = {
      inherit (config.nvcodec) gate;
    };
    ogg = {
      packages = { inherit libogg; };
      flags = [ ]; # There is no flag for OGG?!
      description = "Ogg container used by vorbis & theora";
    };
    openal = {
      variant = full;
      packages = { inherit openal; };
      description = "OpenAL 1.1 capture support";
    };
    opencl = {
      variant = full;
      packages = { inherit ocl-icd opencl-headers; };
    };
    opencore-amr = {
      gate = enable.gplv3;
      variant = full;
      packages = { inherit opencore-amr; };
      flags = [ "libopencore-amrnb" "libopencore-amrwb" ];
    };
    opengl = {
      gate = !stdenv.isDarwin;
      variant = full;
      packages = { inherit libGL libGLU; };
      description = "OpenGL rendering";
    };
    openh264 = {
      variant = full;
      packages = { inherit openh264; };
      flagPrefix = "lib";
    };
    openjpeg = {
      variant = full;
      packages = { inherit openjpeg; };
      flagPrefix = "lib";
    };
    openmpt = {
      variant = full;
      packages = { inherit libopenmpt; };
      flagPrefix = "lib";
      description = "Tracked music files decoder";
    };
    opus = {
      packages = { inherit libopus; };
      flagPrefix = "lib";
    };
    placebo = {
      gate = !stdenv.isDarwin;
      variant = full;
      packages = {
        inherit vulkan-headers;
        libplacebo =
          if lib.versionAtLeast version "6.1"
          then libplacebo
          else libplacebo_5;
      };
      flagPrefix = "lib";
      description = "libplacebo video processing library";
    };
    pulse = {
      gate = stdenv.isLinux;
      variant = small;
      packages = { inherit libpulseaudio; };
      flagPrefix = "lib";
      description = "Pulseaudio input support";
    };
    qrencode = {
      variant = full;
      version = "7";
      packages = { inherit qrencode; };
      flagPrefix = "lib";
      description = "QR encode generation";
    };
    quirc = {
      variant = full;
      version = "7";
      packages = { inherit quirc; };
      flagPrefix = "lib";
      description = "QR decoding";
    };
    rav1e = {
      variant = full;
      packages = { inherit rav1e; };
      flagPrefix = "lib";
      description = "AV1 encoder (focused on speed and safety)";
    };
    rtmp = {
      variant = full;
      packages = { inherit rtmpdump; };
      flagPrefix = "lib";
    };
    samba = {
      variant = full;
      packages = { inherit samba; };
      flags = [ "libsmbclient" ];
    };
    sdl2 = {
      variant = small;
      packages = { inherit SDL2; };
    };
    shaderc = {
      gate = !stdenv.isDarwin;
      variant = full;
      version = "5";
      packages = { inherit shaderc; };
      flagPrefix = "lib";
    };
    soxr = {
      packages = { inherit soxr; };
      flagPrefix = "lib";
      description = "Resampling via soxr";
    };
    speex = {
      packages = { inherit speex; };
      flagPrefix = "lib";
    };
    srt = {
      packages = { inherit srt; };
      flagPrefix = "lib";
      description = "Secure Reliable Transport (SRT) protocol";
    };
    ssh = {
      packages = { inherit libssh; };
      flagPrefix = "lib";
      description = "SFTP protocol";
    };
    svg = {
      variant = full;
      packages = { inherit librsvg; };
      flags = [ "librsvg" ];
    };
    svtav1 = {
      gate = !stdenv.isAarch64 && !stdenv.hostPlatform.isMinGW;
      packages = { inherit svt-av1; };
      flagPrefix = "lib";
      description = "AV1 encoder/decoder (focused on speed and correctness)";
    };
    tensorflow = {
      gate = false; # Increases closure size by ~390 MiB and is rather specialised purpose
      packages = { inherit libtensorflow; };
      flagPrefix = "lib";
      description = "Tensorflow dnn backend support";
    };
    theora = {
      packages = { inherit libtheora; };
      flagPrefix = "lib";
    };
    v4l2 = {
      gate = stdenv.isLinux;
      packages = { inherit libv4l; };
      flags = [ "libv4l2" "v4l2-m2m" ];
      description = "Video 4 Linux";
    };
    vaapi = {
      gate = with stdenv; isLinux || isFreeBSD;
      packages = {
        libva = if variant == headless then libva-minimal else libva;
      };
      description = "Vaapi hardware acceleration";
    };
    vdpau = {
      gate = !stdenv.hostPlatform.isMinGW;
      variant = small;
      packages = { inherit libvdpau; };
      description = "Vdpau hardware acceleration";
    };
    videotoolbox = {
      gate = stdenv.isDarwin;
      packages = { inherit VideoToolbox; };
    };
    vidstab = {
      gate = enable.gpl;
      variant = full;
      packages = { inherit vid-stab; };
      flagPrefix = "lib";
      description = "Video stabilization";
    };
    vmaf = {
      gate = !stdenv.isAarch64;
      variant = full;
      version = "5";
      packages = { inherit libvmaf; };
      flagPrefix = "lib";
      description = "Netflix's VMAF (Video Multi-Method Assessment Fusion)";
    };
    vo-amrwbenc = {
      gate = enable.gplv3;
      variant = full;
      packages = { inherit vo-amrwbenc; };
      flagPrefix = "lib";
    };
    vorbis = {
      packages = { inherit libvorbis; };
      flagPrefix = "lib";
      description = "Vorbis de/encoding, native encoder exists"; # TODO shouldn't we be using it then?
    };
    vpl = {
      # It is currently unclear whether this breaks support for old GPUs. See
      # https://github.com/NixOS/nixpkgs/issues/303074
      gate = false;
      packages = { inherit libvpl; };
      flagPrefix = "lib";
      description = "Hardware acceleration via intel libvpl (incompatible with {option}`mfx`)";
    };
    vpx = {
      gate = stdenv.buildPlatform == stdenv.hostPlatform;
      packages = { inherit libvpx; };
      flagPrefix = "lib";
      description = "VP8 & VP9 de/encoding";
    };
    vulkan = {
      gate = !stdenv.isDarwin;
      variant = small;
      packages = { inherit vulkan-headers vulkan-loader; }; };
    webp = {
      variant = full;
      packages = { inherit libwebp; };
      flagPrefix = "lib";
    };
    x264 = {
      gate = enable.gpl;
      packages = { inherit x264; };
      flagPrefix = "lib";
    };
    x265 = {
      gate = enable.gpl;
      packages = { inherit x265; };
      flagPrefix = "lib";
    };
    xavs = {
      gate = enable.gpl;
      variant = full;
      packages = { inherit xavs; };
      flagPrefix = "lib";
    };
    xcb = {
      gate = with enable; xcb-shape || xcb-shm || xcb-xfixes;
      packages = { inherit libxcb; };
      flagPrefix = "lib";
      description = "X11 grabbing using XCB";
    };
    xcb-shape = {
      variant = full;
      flagPrefix = "lib";
      description = "X11 grabbing shape rendering";
    };
    xcb-shm = {
      variant = full;
      flagPrefix = "lib";
      description = "X11 grabbing shm communication";
    };
    xcb-xfixes = {
      variant = full;
      flagPrefix = "lib";
      description = "X11 grabbing mouse rendering";
    };
    xevd = {
      gate = stdenv.hostPlatform.isx86;
      variant = full;
      version = "7";
      packages = { inherit xevd; };
      flagPrefix = "lib";
      description = "MPEG-5 EVC decoding";
    };
    xeve = {
      gate = stdenv.hostPlatform.isx86;
      variant = full;
      version = "7";
      packages = { inherit xeve; };
      flagPrefix = "lib";
      description = "MPEG-5 EVC encoding";
    };
    xlib = {
      variant = full;
      packages = { inherit libX11 libXv libXext; };
    };
    xml2 = {
      variant = full;
      packages = { inherit libxml2; };
      flagPrefix = "lib";
      description = "libxml2 support, for IMF and DASH demuxers";
    };
    xvid = {
      gate = enable.gpl;
      packages = { inherit xvidcore; };
      flagPrefix = "lib";
      description = "Xvid encoder, native encoder exists"; # TODO shouldn't we be using it then?
    };
    zimg = {
      packages = { inherit zimg; };
      flagPrefix = "lib";
    };
    zlib = { packages = { inherit zlib; }; };
    zmq = {
      variant = full;
      packages = { inherit zeromq4; };
      flagPrefix = "lib";
      description = "Message passing";
    };
  };
in

{
  options = {
    features = lib.mapAttrs mkFfmpegOption (featureOptions (config.features));
    foo = lib.mkOption { default = isInVariant "full"; };
  };
}
