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
, pkgs # TODO
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
  eval = lib.evalModules {
    modules = [
      ./options.nix
      configuration
      {
        _module.args = {
          inherit stdenv pkgs version variants;
          variant = ffmpegVariant;
        };
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
  passthru.config = config;
  passthru.options = eval.options;
  passthru.variants = variants;

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
