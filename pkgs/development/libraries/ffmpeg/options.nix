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
  ffmpegFlag = lib.types.submodule ({ config, name, ... }: {
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
      flagPrefix = "lib";
    };
    appkit = {
      gate = stdenv.isDarwin;
      packages = { inherit AppKit; };
    };
    aribcaption = {
      variant = full;
      packages = { inherit libaribcaption; };
      flagPrefix = "lib";
    };
    ass = {
      gate = stdenv.hostPlatform == stdenv.buildPlatform;
      packages = { inherit libass; };
      flagPrefix = "lib";
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
    };
    celt = {
      variant = full;
      packages = { inherit celt; };
      flagPrefix = "lib";
    };
    chromaprint = {
      variant = full;
      packages = { inherit chromaprint; };
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
    };
    dc1394 = {
      gate = !stdenv.isDarwin;
      variant = full;
      packages = { inherit libdc1394 libraw1394; };
      flagPrefix = "lib";
    };
    drm = {
      gate = with stdenv; isLinux || isFreeBSD;
      packages = { inherit libdrm; };
      flagPrefix = "lib";
    };
    dvdnav = {
      gate = config.gpl;
      variant = full;
      version = "7";
      packages = { inherit libdvdnav; };
      flagPrefix = "lib";
    };
    dvdread = {
      gate = config.gpl;
      variant = full;
      version = "7";
      packages = { inherit libdvdread; };
      flagPrefix = "lib";
    };
    fdk-aac = {
      gate = with config; !gpl || unfree;
      variant = full;
      packages = { inherit fdk_aac; };
      flagPrefix = "lib";
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
    };
    flite = {
      variant = full;
      packages = { inherit flite; };
      flagPrefix = "lib";
    };
    fontconfig = {
      packages = { inherit fontconfig; };
      flags = [ "fontconfig" "libfontconfig" ];
    };
    freetype = {
      packages = { inherit freetype; };
      flagPrefix = "lib";
    };
    frei0r = {
      gate = config.gpl;
      variant = full;
      packages = { inherit frei0r; };
    };
    fribidi = {
      variant = full;
      packages = { inherit fribidi; };
      flagPrefix = "lib";
    };
    gme = {
      variant = full;
      packages = { inherit game-music-emu; };
      flagPrefix = "lib";
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
    };
    lzma = { packages = { inherit xz; }; };
    mfx = {
      gate = with stdenv.hostPlatform; isLinux && !isAarch;
      variant = full;
      packages = { inherit intel-media-sdk; };
      flagPrefix = "lib";
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
    };
    openal = {
      variant = full;
      packages = { inherit openal; };
    };
    opencl = {
      variant = full;
      packages = { inherit ocl-icd opencl-headers; };
    };
    opencore-amr = {
      gate = config.gplv3;
      variant = full;
      packages = { inherit opencore-amr; };
      flags = [ "libopencore-amrnb" "libopencore-amrwb" ];
    };
    opengl = {
      gate = !stdenv.isDarwin;
      variant = full;
      packages = { inherit libGL libGLU; };
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
    };
    pulse = {
      gate = stdenv.isLinux;
      variant = small;
      packages = { inherit libpulseaudio; };
      flagPrefix = "lib";
    };
    qrencode = {
      variant = full;
      version = "7";
      packages = { inherit qrencode; };
      flagPrefix = "lib";
    };
    quirc = {
      variant = full;
      version = "7";
      packages = { inherit quirc; };
      flagPrefix = "lib";
    };
    rav1e = {
      variant = full;
      packages = { inherit rav1e; };
      flagPrefix = "lib";
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
    };
    speex = {
      packages = { inherit speex; };
      flagPrefix = "lib";
    };
    srt = {
      packages = { inherit srt; };
      flagPrefix = "lib";
    };
    ssh = {
      packages = { inherit libssh; };
      flagPrefix = "lib";
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
    };
    tensorflow = {
      gate = false;
      packages = { inherit libtensorflow; };
      flagPrefix = "lib";
    };
    theora = {
      packages = { inherit libtheora; };
      flagPrefix = "lib";
    };
    v4l2 = {
      gate = stdenv.isLinux;
      packages = { inherit libv4l; };
      flags = [ "libv4l2" "v4l2-m2m" ];
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
      flagPrefix = "lib";
    };
    vmaf = {
      gate = !stdenv.isAarch64;
      variant = full;
      version = "5";
      packages = { inherit libvmaf; };
      flagPrefix = "lib";
    };
    vo-amrwbenc = {
      gate = config.gplv3;
      variant = full;
      packages = { inherit vo-amrwbenc; };
      flagPrefix = "lib";
    };
    vorbis = {
      packages = { inherit libvorbis; };
      flagPrefix = "lib";
    };
    vpl = {
      gate = false;
      packages = { inherit libvpl; };
      flagPrefix = "lib";
    };
    vpx = {
      gate = stdenv.buildPlatform == stdenv.hostPlatform;
      packages = { inherit libvpx; };
      flagPrefix = "lib";
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
      gate = config.gpl;
      packages = { inherit x264; };
      flagPrefix = "lib";
    };
    x265 = {
      gate = config.gpl;
      packages = { inherit x265; };
      flagPrefix = "lib";
    };
    xavs = {
      gate = config.gpl;
      variant = full;
      packages = { inherit xavs; };
      flagPrefix = "lib";
    };
    xcb = {
      gate = with (lib.mapAttrs (n: v: v.enable) config); xcb-shape || xcb-shm || xcb-xfixes;
      packages = { inherit libxcb; };
      flagPrefix = "lib";
    };
    xcb-shape = {
      variant = full;
      flagPrefix = "lib";
    };
    xcb-shm = {
      variant = full;
      flagPrefix = "lib";
    };
    xcb-xfixes = {
      variant = full;
      flagPrefix = "lib";
    };
    xevd = {
      gate = stdenv.hostPlatform.isx86;
      variant = full;
      version = "7";
      packages = { inherit xevd; };
      flagPrefix = "lib";
    };
    xeve = {
      gate = stdenv.hostPlatform.isx86;
      variant = full;
      version = "7";
      packages = { inherit xeve; };
      flagPrefix = "lib";
    };
    xlib = {
      variant = full;
      packages = { inherit libX11 libXv libXext; };
    };
    xml2 = {
      variant = full;
      packages = { inherit libxml2; };
      flagPrefix = "lib";
    };
    xvid = {
      gate = config.gpl;
      packages = { inherit xvidcore; };
      flagPrefix = "lib";
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
    };
  };
in

{
  options = {
    features = lib.mapAttrs mkFfmpegOption (featureOptions (config.features // { gpl = true; gplv3 = true; unfree = false; })); # TODO
    foo = lib.mkOption { default = isInVariant "full"; };
  };
}
