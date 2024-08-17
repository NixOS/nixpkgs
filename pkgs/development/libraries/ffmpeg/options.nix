{
  lib,
  config,
  stdenv,
  pkgs, # TODO
  ...
}:


let
  ffmpegFlag = lib.types.submodule {
    options = {
      enable = lib.mkEnableOption "Whether to enable this flag.";
      packages = lib.mkOption {
        type = with lib.types; attrsOf package;
        default = { };
        description = "The dependencies required to enable this flag.";
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
    };
  };

  mkFfmpegOption = name: default: lib.mkOption {
    description = "Whether to enable ${name} in ffmpeg";
    type = ffmpegFlag;
    inherit default; # Default done via ffmpegFlag type
  };

  featureOptions =
    with pkgs;
    {
    config.alsa = { packages = { inherit alsa-lib; }; };
    config.aom = { packages = { inherit libaom; }; };
    appkit = { packages = { inherit AppKit; }; };
    aribcaption = { packages = { inherit libaribcaption; }; };
    ass = { packages = { inherit libass; }; };
    audiotoolbox = { packages = { inherit AudioToolbox; }; };
    avfoundation = { packages = { inherit AVFoundation; }; };
    avisynth = { packages = { inherit avisynthplus; }; };
    bluray = { packages = { inherit libbluray; }; };
    bs2b = { packages = { inherit libbs2b; }; };
    bzlib = { packages = { inherit bzip2; }; };
    caca = { packages = { inherit libcaca; }; };
    celt = { packages = { inherit celt; }; };
    chromaprint = { packages = { inherit chromaprint; }; };
    codec2 = { packages = { inherit codec2; }; };
    coreimage = { packages = { inherit CoreImage; }; };
    dav1d = { packages = { inherit dav1d; }; };
    dc1394 = { packages = { inherit libdc1394 libraw1394; }; };
    drm = { packages = { inherit libdrm; }; };
    dvdnav = { packages = { inherit libdvdnav; }; };
    dvdread = { packages = { inherit libdvdread; }; };
    fdkaac = { packages = { inherit fdk_aac; }; };
    nvcodec = { packages = { inherit (if (lib.versionAtLeast version "6") then nv-codec-headers-12 else nv-codec-headers); }; };
    flite = { packages = { inherit flite; }; };
    fontconfig = { packages = { inherit fontconfig; }; };
    freetype = { packages = { inherit freetype; }; };
    frei0r = { packages = { inherit frei0r; }; };
    fribidi = { packages = { inherit fribidi; }; };
    gme = { packages = { inherit game-music-emu; }; };
    gnutls = { packages = { inherit gnutls; }; };
    gsm = { packages = { inherit gsm; }; };
    harfbuzz = { packages = { inherit harfbuzz; }; };
    iconv = { packages = { inherit libiconv; }; }; # On Linux this should be in libc, do we really need it?
    jack = { packages = { inherit libjack2; }; };
    jxl = { packages = { inherit libjxl; }; };
    ladspa = { packages = { inherit ladspaH; }; };
    lzma = { packages = { inherit xz; }; };
    mfx = { packages = { inherit intel-media-sdk; }; };
    modplug = { packages = { inherit libmodplug; }; };
    mp3lame = { packages = { inherit lame; }; };
    mysofa = { packages = { inherit libmysofa; }; };
    ogg = { packages = { inherit libogg; }; };
    openal = { packages = { inherit openal; }; };
    opencl = { packages = { inherit ocl-icd opencl-headers; }; };
    hopencoreamrnb = { packages = { inherit opencore-amr; }; };
    opengl = { packages = { inherit libGL libGLU; }; };
    openh264 = { packages = { inherit openh264; }; };
    openjpeg = { packages = { inherit openjpeg; }; };
    openmpt = { packages = { inherit libopenmpt; }; };
    opus = { packages = { inherit libopus; }; };
    placebo = { packages = { inherit (if (lib.versionAtLeast version "6.1") then libplacebo else libplacebo_5) vulkan-headers; }; };
    pulse = { packages = { inherit libpulseaudio; }; };
    qrencode = { packages = { inherit qrencode; }; };
    quirc = { packages = { inherit quirc; }; };
    rav1e = { packages = { inherit rav1e; }; };
    rtmp = { packages = { inherit rtmpdump; }; };
    samba = { packages = { inherit samba; }; };
    sdl2 = { packages = { inherit SDL2; }; };
    shaderc = { packages = { inherit shaderc; }; };
    soxr = { packages = { inherit soxr; }; };
    speex = { packages = { inherit speex; }; };
    srt = { packages = { inherit srt; }; };
    ssh = { packages = { inherit libssh; }; };
    svg = { packages = { inherit librsvg; }; };
    svtav1 = { packages = { inherit svt-av1; }; };
    tensorflow = { packages = { inherit libtensorflow; }; };
    theora = { packages = { inherit libtheora; }; };
    v4l2 = { packages = { inherit libv4l; }; };
    vaapi = { packages = { inherit (if withSmallDeps then libva else libva-minimal); }; };
    vdpau = { packages = { inherit libvdpau; }; };
    videotoolbox = { packages = { inherit VideoToolbox; }; };
    vidstab = { packages = { inherit vid-stab; }; };
    vmaf = { packages = { inherit libvmaf; }; };
    voamrwbenc = { packages = { inherit vo-amrwbenc; }; };
    vorbis = { packages = { inherit libvorbis; }; };
    vpl = { packages = { inherit libvpl; }; };
    vpx = { packages = { inherit libvpx; }; };
    vulkan = { packages = { inherit vulkan-headers vulkan-loader; }; };
    webp = { packages = { inherit libwebp; }; };
    x264 = { packages = { inherit x264; }; };
    x265 = { packages = { inherit x265; }; };
    xavs = { packages = { inherit xavs; }; };
    xcb = { packages = { inherit libxcb; }; };
    xevd = { packages = { inherit xevd; }; };
    xeve = { packages = { inherit xeve; }; };
    xlib = { packages = { inherit libX11 libXv libXext; }; };
    xml2 = { packages = { inherit libxml2; }; };
    xvid = { packages = { inherit xvidcore; }; };
    zimg = { packages = { inherit zimg; }; };
    zlib = { packages = { inherit zlib; }; };
    zmq = { packages = { inherit zeromq4; }; };
  };
in

{
  options = {

  };
}
