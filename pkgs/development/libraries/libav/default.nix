{ stdenv, fetchurl, pkgconfig, yasm, bzip2, zlib
, mp3Support    ? true,   lame      ? null
, speexSupport  ? true,   speex     ? null
, theoraSupport ? true,   libtheora ? null
, vorbisSupport ? true,   libvorbis ? null
, vpxSupport    ? true,   libvpx    ? null
, x264Support   ? false,  x264      ? null
, xvidSupport   ? true,   xvidcore  ? null
, faacSupport   ? false,  faac      ? null
, vaapiSupport  ? false,  libva     ? null # ToDo: it has huge closure
, vdpauSupport  ? true,   libvdpau  ? null
, freetypeSupport ? true, freetype  ? null # it's small and almost everywhere
, SDL # only for avplay in $tools, adds nontrivial closure to it
, enableGPL ? true # ToDo: some additional default stuff may need GPL
, enableUnfree ? faacSupport
}:

assert faacSupport -> enableUnfree;

with { inherit (stdenv.lib) optional optionals; };

/* ToDo:
    - more deps, inspiration: http://packages.ubuntu.com/raring/libav-tools
    - maybe do some more splitting into outputs
*/

let
  result = {
    libav_9   = libavFun   "9.9" "1rwphyqb2c4zyp20y4ywxjiddmd46vd4dbpdm1lxqm3q63rmmdk9";
    libav_0_8 = libavFun "0.8.8" "1wnbmbs0z4f55y8r9bwb63l04zn383l1avy4c9x1ffb2xccgcp79";
  };

  libavFun = version : sha256 : stdenv.mkDerivation rec {
    name = "libav-${version}";

    src = fetchurl {
      url = "http://libav.org/releases/${name}.tar.xz";
      inherit sha256;
    };
    configureFlags =
      assert stdenv.lib.all (x: x!=null) buildInputs;
    [
      #"--enable-postproc" # it's now a separate package in upstream
      "--disable-avserver" # upstream says it's in a bad state
      "--enable-avplay"
      "--enable-shared"
      "--enable-runtime-cpudetect"
    ]
      ++ optionals enableGPL [ "--enable-gpl" "--enable-swscale" ]
      ++ optional mp3Support "--enable-libmp3lame"
      ++ optional speexSupport "--enable-libspeex"
      ++ optional theoraSupport "--enable-libtheora"
      ++ optional vorbisSupport "--enable-libvorbis"
      ++ optional vpxSupport "--enable-libvpx"
      ++ optional x264Support "--enable-libx264"
      ++ optional xvidSupport "--enable-libxvid"
      ++ optional faacSupport "--enable-libfaac --enable-nonfree"
      ++ optional vaapiSupport "--enable-vaapi"
      ++ optional vdpauSupport "--enable-vdpau"
      ++ optional freetypeSupport "--enable-libfreetype"
      ;

    buildInputs = [ pkgconfig lame yasm zlib bzip2 SDL ]
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

    outputs = [ "out" "tools" ];

    postInstall = ''
      mkdir -p "$tools/bin"
      mv "$out/bin/avplay" "$tools/bin"
      cp -s "$out"/bin/* "$tools/bin/"
    '';

    doInstallCheck = true;
    installCheckTarget = "check"; # tests need to be run *after* installation

    crossAttrs = {
      dontSetConfigureCross = true;
      configureFlags = configureFlags ++ [
        "--cross-prefix=${stdenv.cross.config}-"
        "--enable-cross-compile"
        "--target_os=linux"
        "--arch=${stdenv.cross.arch}"
        ];
    };

    passthru = { inherit vdpauSupport; };

    meta = with stdenv.lib; {
      homepage = http://libav.org/;
      description = "A complete, cross-platform solution to record, convert and stream audio and video (fork of ffmpeg)";
      license = with licenses; if enableUnfree then unfree #ToDo: redistributable or not?
        else if enableGPL then gpl2Plus else lgpl21Plus;
      platforms = platforms.all;
    };
  }; # libavFun

in result

