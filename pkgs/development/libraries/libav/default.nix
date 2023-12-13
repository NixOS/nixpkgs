{ lib, stdenv, fetchurl, pkg-config, yasm, bzip2, zlib, perl, bash
, mp3Support    ? true,   lame      ? null
, speexSupport  ? true,   speex     ? null
, theoraSupport ? true,   libtheora ? null
, vorbisSupport ? true,   libvorbis ? null
, vpxSupport    ? true,   libvpx    ? null
, x264Support   ? false,  x264      ? null
, xvidSupport   ? true,   xvidcore  ? null
, faacSupport   ? false,  faac      ? null
, vaapiSupport  ? true,   libva     ? null
, vdpauSupport  ? true,   libvdpau  ? null
, freetypeSupport ? true, freetype  ? null # it's small and almost everywhere
, SDL # only for avplay in $bin, adds nontrivial closure to it
, enableGPL ? true # ToDo: some additional default stuff may need GPL
, enableUnfree ? faacSupport
}:

assert faacSupport -> enableUnfree;

let inherit (lib) optional optionals hasPrefix enableFeature; in

/* ToDo:
    - more deps, inspiration: https://packages.ubuntu.com/raring/libav-tools
    - maybe do some more splitting into outputs
*/

let
  result = {
    # e.g. https://libav.org/releases/libav-11.11.tar.xz.sha1
    libav_0_8 = libavFun "0.8.21" "d858f65128dad0bac1a8c3a51e5cbb27a7c79b3f";
    libav_11  = libavFun "11.12"  "61d5dcab5fde349834af193a572b12a5fd6a4d42";
    libav_12  = libavFun "12.3"   "386c18c8b857f23dfcf456ce40370716130211d9";
  };

  libavFun = version : sha1 : stdenv.mkDerivation rec {
    pname = "libav";
    inherit version;

    src = fetchurl {
      url = "${meta.homepage}/releases/${pname}-${version}.tar.xz";
      inherit sha1; # upstream directly provides sha1 of releases over https
    };

    patches = []
      ++ optional (vpxSupport && hasPrefix "0.8." version) ./vpxenc-0.8.17-libvpx-1.5.patch
      ++ optional (vpxSupport && hasPrefix "12." version) ./vpx-12.3-libvpx-1.8.patch
      ;

    postPatch = ''
      patchShebangs .
      # another shebang was hidden in a here document text
      substituteInPlace ./configure --replace "#! /bin/sh" "#!${bash}/bin/sh"
    '';

    configurePlatforms = [];
    configureFlags = assert lib.all (x: x!=null) buildInputs; [
      "--arch=${stdenv.hostPlatform.parsed.cpu.name}"
      "--target_os=${stdenv.hostPlatform.parsed.kernel.name}"
      #"--enable-postproc" # it's now a separate package in upstream
      "--disable-avserver" # upstream says it's in a bad state
      "--enable-avplay"
      "--enable-shared"
      "--enable-runtime-cpudetect"
      "--cc=${stdenv.cc.targetPrefix}cc"
      (enableFeature enableGPL "gpl")
      (enableFeature enableGPL "swscale")
      (enableFeature mp3Support "libmp3lame")
      (enableFeature mp3Support "libmp3lame")
      (enableFeature speexSupport "libspeex")
      (enableFeature theoraSupport "libtheora")
      (enableFeature vorbisSupport "libvorbis")
      (enableFeature vpxSupport "libvpx")
      (enableFeature x264Support "libx264")
      (enableFeature xvidSupport "libxvid")
      (enableFeature faacSupport "libfaac")
      (enableFeature faacSupport "nonfree")
      (enableFeature vaapiSupport "vaapi")
      (enableFeature vdpauSupport "vdpau")
      (enableFeature freetypeSupport "libfreetype")
    ] ++ optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      "--cross-prefix=${stdenv.cc.targetPrefix}"
      "--enable-cross-compile"
    ];

  nativeBuildInputs = [ pkg-config perl ];
    buildInputs = [ lame yasm zlib bzip2 SDL bash ]
      ++ [ perl ] # for install-man target
      ++ optional mp3Support lame
      ++ optional speexSupport speex
      ++ optional theoraSupport libtheora
      ++ optional vorbisSupport libvorbis
      ++ optional vpxSupport libvpx
      ++ optional x264Support x264
      ++ optional xvidSupport xvidcore
      ++ optional faacSupport faac
      ++ optional vaapiSupport libva
      ++ optional vdpauSupport libvdpau
      ++ optional freetypeSupport freetype
      ;

    enableParallelBuilding = true;

    outputs = [ "bin" "dev" "out" ];
    setOutputFlags = false;

    # alltools to build smaller tools, incl. aviocat, ismindex, qt-faststart, etc.
    buildFlags = [ "all" "alltools" "install-man" ];


    postInstall = ''
      moveToOutput bin "$bin"
      # alltools target compiles an executable in tools/ for every C
      # source file in tools/, so move those to $out
      for tool in $(find tools -type f -executable); do
        mv "$tool" "$bin/bin/"
      done
    '';

    doInstallCheck = false; # fails randomly
    installCheckTarget = "check"; # tests need to be run *after* installation

    passthru = { inherit vdpauSupport; };

    meta = with lib; {
      homepage = "https://libav.org/";
      description = "A complete, cross-platform solution to record, convert and stream audio and video (fork of ffmpeg)";
      license = with licenses; if enableUnfree then unfree #ToDo: redistributable or not?
        else if enableGPL then gpl2Plus else lgpl21Plus;
      platforms = with platforms; linux ++ darwin;
      knownVulnerabilities =
        lib.optional (lib.versionOlder version "12.1") "CVE-2017-9051"
        ++ lib.optionals (lib.versionOlder version "12.3") [ "CVE-2018-5684" "CVE-2018-5766" ]
        ++ lib.optionals (lib.versionOlder version "12.4") [ "CVE-2019-9717" "CVE-2019-9720" ];
    };
  }; # libavFun

in result
