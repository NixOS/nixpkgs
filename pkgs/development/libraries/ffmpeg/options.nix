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
  isInVariant = v:
    let
      checks = rec {
        full = variant == variants.full;
        small = variant == variants.small || full;
        headless = variant == variants.headless || small;
      };
    in checks.${v} or false;
  ffmpegFlag = lib.types.submodule ({ config, ... }: {
    options = {
      enable = lib.mkEnableOption "Whether to enable this feature." // lib.mkOption {
        # TODO this works but doesn't allow for convenient overrides yet. You
        # can easily override enable = true but it will still be gated behind
        # the variant check.
        default = isInVariant config.variant && config.gate;
      };
      packages = lib.mkOption {
        type = with lib.types; attrsOf package;
        default = { };
        description = "The dependencies required to enable this feature.";
      };
      version = lib.mkOption {
        type = lib.types.str;
        default = "0"; # Unknown/Enable in any version
        description = "Minimum version that understands this flag. Flag will not be passed when lower.";
      };
      variant = lib.mkOption {
        type = lib.types.enum [ "headless" "small" "full" ];
        default = "headless";
        # description = policy here
      };

      # TODO how to handle this better?
      # Could you make use of priorities here?
      # Use config = ?
      gate = lib.mkOption {
        default = true;
        description = ''
          Gates the default value for {option}`enable` behind a boolean. Use
          this to disable certain features on certain platforms by default.
        '';
      };
    };
  });

  mkFfmpegOption = name: default: lib.mkOption {
    description = "Whether to enable ${name} in ffmpeg";
    type = ffmpegFlag;
    inherit default; # Default done via ffmpegFlag type
  };

  inherit (variants) headless small full;

  featureOptions = config:
    # FIXME
    with pkgs;
    with pkgs.darwin.apple_sdk.frameworks;
    with pkgs.xorg;
    {
    alsa = { packages = { inherit alsa-lib; }; };
    aom = {
      variant = full;
      packages = { inherit libaom; };
    };
    appkit = {
      gate = stdenv.isDarwin;
      packages = { inherit AppKit; };
    };
    aribcaption = {
      variant = full;
      packages = { inherit libaribcaption; };
    };
    ass = {
      gate = stdenv.hostPlatform == stdenv.buildPlatform;
      packages = { inherit libass; };
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
    };
    bluray = {
      variant = full;
      packages = { inherit libbluray; };
    };
    bs2b = {
      variant = full;
      packages = { inherit libbs2b; };
    };
    bzlib = { packages = { inherit bzip2; }; };
    caca = {
      variant = full;
      packages = { inherit libcaca; };
    };
    celt = {
      variant = full;
      packages = { inherit celt; };
    };
    chromaprint = {
      variant = full;
      packages = { inherit chromaprint; };
    };
    codec2 = {
      variant = full;
      packages = { inherit codec2; };
    };
    coreimage = {
      gate = stdenv.isDarwin;
      packages = { inherit CoreImage; };
    };
    cuda = {
      inherit (config.nvcodec) gate;
      variant = full;
    };
    cudallvm = {
      variant = full;
    };
    cuvid = {
      inherit (config.nvcodec) gate;
    };
    dav1d = { packages = { inherit dav1d; }; };
    dc1394 = {
      gate = !stdenv.isDarwin;
      variant = full;
      packages = { inherit libdc1394 libraw1394; };
    };
    drm = {
      gate = with stdenv; isLinux || isFreeBSD;
      packages = { inherit libdrm; };
    };
    dvdnav = {
      gate = config.gpl;
      variant = full;
      version = "7";
      packages = { inherit libdvdnav; };
    };
    dvdread = {
      gate = config.gpl;
      variant = full;
      version = "7";
      packages = { inherit libdvdread; };
    };
    fdkaac = {
      gate = with config; !gpl || unfree;
      variant = full;
      packages = { inherit fdk_aac; };
    };
    nvcodec = {
      gate = with stdenv; !isDarwin && !isAarch32 && !hostPlatform.isRiscV && hostPlatform == buildPlatform;
      packages = {
        nv-codec-headers =
          if lib.versionAtLeast version "6"
          then nv-codec-headers-12
          else nv-codec-headers;
      };
    };
    flite = {
      variant = full;
      packages = { inherit flite; };
    };
    fontconfig = { packages = { inherit fontconfig; }; };
    freetype = { packages = { inherit freetype; }; };
    frei0r = {
      gate = config.gpl;
      variant = full;
      packages = { inherit frei0r; };
    };
    fribidi = {
      variant = full;
      packages = { inherit fribidi; };
    };
    gme = {
      variant = full;
      packages = { inherit game-music-emu; };
    };
    gnutls = { packages = { inherit gnutls; }; };
    gsm = {
      variant = full;
      packages = { inherit gsm; };
    };
    harfbuzz = {
      version = "6.1";
      packages = { inherit harfbuzz; };
    };
    iconv = { packages = { inherit libiconv; }; }; # On Linux this should be in libc, do we really need it?
    jack = {
      gate = !stdenv.isDarwin;
      variant = full;
      packages = { inherit libjack2; };
    };
    jxl = {
      variant = full;
      version = "5";
      packages = { inherit libjxl; };
    };
    ladspa = {
      variant = full;
      packages = { inherit ladspaH; };
    };
    lzma = { packages = { inherit xz; }; };
    mfx = {
      gate = with stdenv.hostPlatform; isLinux && !isAarch;
      variant = full;
      packages = { inherit intel-media-sdk; };
    };
    modplug = {
      gate = !stdenv.isDarwin;
      variant = full;
      packages = { inherit libmodplug; };
    };
    mp3lame = { packages = { inherit lame; }; };
    mysofa = {
      variant = full;
      packages = { inherit libmysofa; };
    };
    nvdec = {
      inherit (config.nvcodec) gate;
    };
    nvenc = {
      inherit (config.nvcodec) gate;
    };
    ogg = { packages = { inherit libogg; }; };
    openal = {
      variant = full;
      packages = { inherit openal; };
    };
    opencl = {
      variant = full;
      packages = { inherit ocl-icd opencl-headers; };
    };
    opencoreamrnb = {
      gate = config.gplv3;
      variant = full;
      packages = { inherit opencore-amr; };
    };
    opengl = {
      gate = !stdenv.isDarwin;
      variant = full;
      packages = { inherit libGL libGLU; };
    };
    openh264 = {
      variant = full;
      packages = { inherit openh264; };
    };
    openjpeg = {
      variant = full;
      packages = { inherit openjpeg; };
    };
    openmpt = {
      variant = full;
      packages = { inherit libopenmpt; };
    };
    opus = { packages = { inherit libopus; }; };
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
    };
    pulse = {
      gate = stdenv.isLinux;
      variant = small;
      packages = { inherit libpulseaudio; };
    };
    qrencode = {
      variant = full;
      version = "7";
      packages = { inherit qrencode; };
    };
    quirc = {
      variant = full;
      version = "7";
      packages = { inherit quirc; };
    };
    rav1e = {
      variant = full;
      packages = { inherit rav1e; };
    };
    rtmp = {
      variant = full;
      packages = { inherit rtmpdump; };
    };
    samba = {
      variant = full;
      packages = { inherit samba; };
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
    };
    soxr = { packages = { inherit soxr; }; };
    speex = { packages = { inherit speex; }; };
    srt = { packages = { inherit srt; }; };
    ssh = { packages = { inherit libssh; }; };
    svg = {
      variant = full;
      packages = { inherit librsvg; };
    };
    svtav1 = {
      gate = !stdenv.isAarch64 && !stdenv.hostPlatform.isMinGW;
      packages = { inherit svt-av1; };
    };
    tensorflow = {
      gate = false;
      packages = { inherit libtensorflow; };
    };
    theora = { packages = { inherit libtheora; }; };
    v4l2 = {
      gate = stdenv.isLinux;
      packages = { inherit libv4l; };
    };
    vaapi = {
      gate = with stdenv; isLinux || isFreeBSD;
      packages = {
        libva = if variant == headless then libva-minimal else libva;
      };
    };
    vdpau = {
      gate = !stdenv.hostPlatform.isMinGW;
      variant = small;
      packages = { inherit libvdpau; };
    };
    videotoolbox = {
      gate = stdenv.isDarwin;
      packages = { inherit VideoToolbox; };
    };
    vidstab = {
      gate = config.gpl;
      variant = full;
      packages = { inherit vid-stab; };
    };
    vmaf = {
      gate = !stdenv.isAarch64;
      variant = full;
      version = "5";
      packages = { inherit libvmaf; };
    };
    voamrwbenc = {
      gate = config.gplv3;
      variant = full;
      packages = { inherit vo-amrwbenc; };
    };
    vorbis = { packages = { inherit libvorbis; }; };
    vpl = {
      gate = false;
      packages = { inherit libvpl; };
    };
    vpx = {
      gate = stdenv.buildPlatform == stdenv.hostPlatform;
      packages = { inherit libvpx; };
    };
    vulkan = {
      gate = !stdenv.isDarwin;
      variant = small;
      packages = { inherit vulkan-headers vulkan-loader; }; };
    webp = {
      variant = full;
      packages = { inherit libwebp; };
    };
    x264 = {
      gate = config.gpl;
      packages = { inherit x264; };
    };
    x265 = {
      gate = config.gpl;
      packages = { inherit x265; };
    };
    xavs = {
      gate = config.gpl;
      variant = full;
      packages = { inherit xavs; };
    };
    xcb = {
      gate = with (lib.mapAttrs (n: v: v.enable) config); xcbshape || xcbshm || xcbxfixes;
      packages = { inherit libxcb; };
    };
    xcbshape = { variant = full; };
    xcbshm = { variant = full; };
    xcbxfixes = { variant = full; };
    xevd = {
      gate = stdenv.hostPlatform.isx86;
      variant = full;
      version = "7";
      packages = { inherit xevd; };
    };
    xeve = {
      gate = stdenv.hostPlatform.isx86;
      variant = full;
      version = "7";
      packages = { inherit xeve; };
    };
    xlib = {
      variant = full;
      packages = { inherit libX11 libXv libXext; };
    };
    xml2 = {
      variant = full;
      packages = { inherit libxml2; };
    };
    xvid = {
      gate = config.gpl;
      packages = { inherit xvidcore; };
    };
    zimg = { packages = { inherit zimg; }; };
    zlib = { packages = { inherit zlib; }; };
    zmq = {
      variant = full;
      packages = { inherit zeromq4; };
    };
  };
in

{
  options = {
    features = lib.mapAttrs mkFfmpegOption (featureOptions (config.features // { gpl = true; gplv3 = true; unfree = false; })); # TODO
    foo = lib.mkOption { default = isInVariant "full"; };

  };

  # config = {
  #   features.tensorflow.gate = true;
  # };
}
