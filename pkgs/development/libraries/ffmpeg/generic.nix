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
, withHeadlessDeps ? ffmpegVariant == "headless" || withSmallDeps
, withSmallDeps ? ffmpegVariant == "small" || withFullDeps
, withFullDeps ? ffmpegVariant == "full"

, fetchgit
, fetchpatch2


/*
 *  Build options
 */
, withPixelutils ? withHeadlessDeps # Pixel utils in libavutil

/*
 *  Program options
 */
, buildFfmpeg ? withHeadlessDeps # Build ffmpeg executable
, buildFfplay ? withSmallDeps # Build ffplay executable
, buildFfprobe ? withHeadlessDeps # Build ffprobe executable
, buildQtFaststart ? withFullDeps # Build qt-faststart executable # TODO
, withBin ? buildFfmpeg || buildFfplay || buildFfprobe || buildQtFaststart # TODO
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
, withLib ? buildAvcodec # TODO
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
, withDocumentation ? withHtmlDoc || withManPages || withPodDoc || withTxtDoc # TODO
, withHtmlDoc ? withHeadlessDeps # HTML documentation pages
, withManPages ? withHeadlessDeps # Man documentation pages
, withPodDoc ? withHeadlessDeps # POD documentation pages
, withTxtDoc ? withHeadlessDeps # Text documentation pages
# Whether a "doc" output will be produced. Note that withManPages does not produce
# a "doc" output because its files go to "man".
, withDoc ? withDocumentation && (withHtmlDoc || withPodDoc || withTxtDoc) # TODO

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

, configuration ? { }
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
  inherit (lib) optional optionals optionalString versionOlder versionAtLeast;
  variants = lib.genAttrs [ "headless" "small" "full" ] lib.id;
  module =
    {
      config,
      ...
    }:

    let
      # Checks whether the given variant of the flag is contained in the currently
      # active variant. full ⊃ small ⊃ headless
      isInVariant = flagVariant:
        let
          checks = {
            full = ffmpegVariant == variants.full;
            small = ffmpegVariant == variants.small || checks.full;
            headless = ffmpegVariant == variants.headless || checks.small;
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
        let
          enable = lib.mapAttrs (n: v: v.enable) config;
        in
          {
            #  Licensing flags
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
            #  Build flags
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

            # Program flags
            ffmpeg = { };
            ffplay = { variant = small; };
            ffprobe = { };

            # Library flags
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

            # Documentation flags
            doc = { };
            htmlpages = { };
            manpages = { };
            podpages = { };
            txtpages = { };

            # Developer flags
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
                libva = if ffmpegVariant == headless then libva-minimal else libva;
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
      };
    };

  eval = lib.evalModules {
    modules = [
      module
      configuration
      {
        _module.args = { variant = ffmpegVariant; };
      }
    ];
  };
  inherit (eval) config;
  inherit (config) features;

  # Feature flags
  withCuda = features.cuda.enable;
  withCudaLLVM = features.cuda-llvm.enable;
  withCuvid = features.cuvid.enable;
  withNvcodec = features.nvcodec.enable;
  withFrei0r = features.frei0r.enable;
  withMfx = features.mfx.enable;
  withNvdec = features.nvdec.enable;
  withNvenc = features.nvenc.enable;
  withVpl = features.vpl.enable;
  withVulkan = features.vulkan.enable;
  withGPL = features.gpl.enable;
  withVersion3 = features.version3.enable;
  withGPLv3 = features.gplv3.enable;
  withUnfree = features.unfree.enable;
in

assert builtins.hasAttr ffmpegVariant variants;

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
    ])
    ++ (lib.optionals (lib.versionAtLeast version "7.0") [
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

    "--datadir=${placeholder "data"}/share/ffmpeg"
  ] ++ optionals withBin [
    "--bindir=${placeholder "bin"}/bin"
  ] ++ optionals withLib [
    "--libdir=${placeholder "lib"}/lib"
    "--incdir=${placeholder "dev"}/include"
  ] ++ optionals withManPages [
    "--mandir=${placeholder "man"}/share/man"
  ] ++ optionals withDoc [
    "--docdir=${placeholder "doc"}/share/doc/ffmpeg"
  ] ++ optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "--cross-prefix=${stdenv.cc.targetPrefix}"
    "--enable-cross-compile" # TODO
    "--host-cc=${buildPackages.stdenv.cc}/bin/cc"
  ] ++ optionals stdenv.cc.isClang [
    "--cc=clang"
    "--cxx=clang++"
  ] ++ lib.pipe eval.config.features [
    (lib.filterAttrs (n: v: lib.versionAtLeast version v.version && lib.versionOlder version v.versionMax))
    (lib.mapAttrsToList (n: feature: (map (lib.enableFeature feature.enable) feature.flags)))
    lib.flatten
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

  buildInputs = lib.pipe eval.config.features [
    (lib.filterAttrs (n: v: v.enable && lib.versionAtLeast version v.version && lib.versionOlder version v.versionMax))
    (lib.mapAttrsToList (n: v: lib.attrValues v.packages))
    lib.flatten
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
  passthru.variants = variants;
  passthru.eval = eval;

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
