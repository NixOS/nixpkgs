{ alsa-lib
, cmake
, copyDesktopItems
, curl
, fetchFromBitbucket
, fetchFromGitHub
, ghc_filesystem
, glew
, glfw
, zenity
, gtk3-x11
, imagemagick
, jansson
, jq
, lib
, libarchive
, libicns
, libjack2
, libpulseaudio
, libsamplerate
, makeDesktopItem
, makeWrapper
, pkg-config
, rtmidi
, speexdsp
, stdenv
, wrapGAppsHook3
, zstd
}:

let
  # The package repo vendors some of the package dependencies as submodules.
  # Unfortunately, they are not pinned, so we have no guarantee that they
  # will be stable, and therefore, we can't use them directly. Instead
  # we'll have to fetch them separately ourselves.
  pffft-source = fetchFromBitbucket {
    owner = "jpommier";
    repo = "pffft";
    rev = "fbc4058602803f40dc554b8a5d2bcc694c005f2f";
    sha256 = "16biji3115232cr1j975hpxw68lfybajlspnhfjcwg8jz2d8ybrf";
  };
  fuzzysearchdatabase-source = fetchFromBitbucket {
    owner = "j_norberg";
    repo = "fuzzysearchdatabase";
    rev = "23122d1ff60d936fd766361a30210c954e0c5449";
    sha256 = "1s88blx1rn2racmb8n5g0kh1ym7v21573l5m42c4nz266vmrvrvz";
  };
  nanovg-source = fetchFromGitHub {
    owner = "VCVRack";
    repo = "nanovg";
    rev = "0bebdb314aff9cfa28fde4744bcb037a2b3fd756";
    sha256 = "HmQhCE/zIKc3f+Zld229s5i5MWzRrBMF9gYrn8JVQzg=";
  };
  nanosvg-source = fetchFromGitHub {
    owner = "memononen";
    repo = "nanosvg";
    rev = "9da543e8329fdd81b64eb48742d8ccb09377aed1";
    sha256 = "1pkzv75kavkhrbdd2kvq755jyr0vamgrfr7lc33dq3ipkzmqvs2l";
  };
  osdialog-source = fetchFromGitHub {
    owner = "AndrewBelt";
    repo = "osdialog";
    rev = "d0f64f0798c2e47f61d90a5505910ff2d63ca049";
    sha256 = "1d3058x6wgzw7b0wai792flk7s6ffw0z4n9sl016v91yjwv7ds3a";
  };
  oui-blendish-source = fetchFromGitHub {
    owner = "VCVRack";
    repo = "oui-blendish";
    rev = "2fc6405883f8451944ed080547d073c8f9f31898";
    sha256 = "1bs0654312555vm7nzswsmky4l8759bjdk17pl22p49rw9k4a1px";
  };
  simde-source = fetchFromGitHub {
    owner = "simd-everywhere";
    repo = "simde";
    rev = "416091ebdb9e901b29d026633e73167d6353a0b0";
    sha256 = "064ygc6c737yjx04rydwwhkr4n4s4rbvj27swxwyzvp1h8nka6xf";
  };
  tinyexpr-source = fetchFromGitHub {
    owner = "codeplea";
    repo = "tinyexpr";
    rev = "9907207e5def0fabdb60c443517b0d9e9d521393";
    sha256 = "0xbpd09zvrk2ppm1qm1skk6p50mqr9mzjixv3s0biqq6jpabs88l";
  };
  fundamental-source = fetchFromGitHub {
    owner = "VCVRack";
    repo = "Fundamental";
    rev = "5ed79544161e0fa9a55faa7c0a5f299e828e12ab"; # tip of branch v2
    sha256 = "0c6qpigyr0ppvra20hcy1fdcmqa212jckb9wkx4f6fgdby7565wv";
  };
  vcv-rtaudio = stdenv.mkDerivation rec {
    pname = "vcv-rtaudio";
    version = "unstable-2020-01-30";

    src = fetchFromGitHub {
      owner = "VCVRack";
      repo = "rtaudio";
      rev = "ece277bd839603648c80c8a5f145678e13bc23f3"; # tip of master branch
      sha256 = "11gpl0ak757ilrq4fi0brj0chmlcr1hihc32yd7qza4fxjw2yx2v";
    };

    nativeBuildInputs = [ cmake pkg-config ];

    buildInputs = [ alsa-lib libjack2 libpulseaudio ];

    cmakeFlags = [
      "-DRTAUDIO_API_ALSA=ON"
      "-DRTAUDIO_API_PULSE=ON"
      "-DRTAUDIO_API_JACK=ON"
      "-DRTAUDIO_API_CORE=OFF"
    ];
  };
in
stdenv.mkDerivation rec {
  pname = "vcv-rack";
  version = "2.5.1";

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = pname;
      desktopName = "VCV Rack";
      genericName = "Eurorack simulator";
      comment = "Create music by patching together virtual synthesizer modules";
      exec = "Rack";
      icon = "Rack";
      categories = [ "AudioVideo" "AudioVideoEditing" "Audio" ];
      keywords = [ "music" ];
    })
  ];

  src = fetchFromGitHub {
    owner = "VCVRack";
    repo = "Rack";
    rev = "v${version}";
    sha256 = "1q2bwjfn6crk9lyd6m3py0v754arw1xgpv5kkj6ka1bc2yz839qh";
  };

  patches = [
    ./rack-minimize-vendoring.patch
  ];

  prePatch = ''
    # As we can't use `make dep` to set up the dependencies (as explained
    # above), we do it here manually
    mkdir -p dep/include

    cp -r ${pffft-source}/* dep/pffft
    cp -r ${fuzzysearchdatabase-source}/* dep/fuzzysearchdatabase
    cp -r ${nanovg-source}/* dep/nanovg
    cp -r ${nanosvg-source}/* dep/nanosvg
    cp -r ${osdialog-source}/* dep/osdialog
    cp -r ${oui-blendish-source}/* dep/oui-blendish
    cp -r ${simde-source}/* dep/simde
    cp -r ${tinyexpr-source}/* dep/tinyexpr

    cp dep/pffft/*.h dep/include
    cp dep/fuzzysearchdatabase/src/*.hpp dep/include
    cp dep/nanosvg/**/*.h dep/include
    cp dep/nanovg/src/*.h dep/include
    cp dep/osdialog/*.h dep/include
    cp dep/oui-blendish/*.h dep/include
    cp -r dep/simde/simde dep/include
    cp dep/tinyexpr/tinyexpr.h dep/include

    # Build and dist the Fundamental plugins
    cp -r ${fundamental-source} plugins/Fundamental/
    chmod -R +rw plugins/Fundamental # will be used as build dir
    substituteInPlace plugin.mk --replace ":= all" ":= dist"
    substituteInPlace plugins/Fundamental/src/Logic.cpp \
      --replace \
        "LightButton<VCVBezelBig, VCVBezelLightBig<WhiteLight>>" \
        "struct rack::componentlibrary::LightButton<VCVBezelBig, VCVBezelLightBig<WhiteLight>>"

    # Fix reference to zenity
    substituteInPlace dep/osdialog/osdialog_zenity.c \
      --replace 'zenityBin[] = "zenity"' 'zenityBin[] = "${zenity}/bin/zenity"'
  '';

  nativeBuildInputs = [
    copyDesktopItems
    imagemagick
    jq
    libicns
    makeWrapper
    pkg-config
    wrapGAppsHook3
  ];
  buildInputs = [
    alsa-lib
    curl
    ghc_filesystem
    glew
    glfw
    zenity
    gtk3-x11
    jansson
    libarchive
    libjack2
    libpulseaudio
    libsamplerate
    rtmidi
    speexdsp
    vcv-rtaudio
    zstd
  ];

  makeFlags = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ] ++ [
    "all"
    "plugins"
  ];

  installPhase = ''
    runHook preInstall

    install -D -m755 -t $out/bin Rack
    install -D -m755 -t $out/lib libRack.so

    mkdir -p $out/share/vcv-rack
    cp -r res cacert.pem Core.json template.vcv LICENSE-GPLv3.txt $out/share/vcv-rack
    cp -r plugins/Fundamental/dist/Fundamental-*.vcvplugin $out/share/vcv-rack/Fundamental.vcvplugin

    # Extract pngs from the Apple icon image and create
    # the missing ones from the 1024x1024 image.
    icns2png --extract icon.icns
    for size in 16 24 32 48 64 128 256 512 1024; do
      mkdir -pv $out/share/icons/hicolor/"$size"x"$size"/apps
      if [ ! -e icon_"$size"x"$size"x32.png ] ; then
        convert -resize "$size"x"$size" icon_1024x1024x32.png icon_"$size"x"$size"x32.png
      fi
      install -Dm644 icon_"$size"x"$size"x32.png $out/share/icons/hicolor/"$size"x"$size"/apps/Rack.png
    done;

    runHook postInstall
  '';

  dontWrapGApps = true;
  postFixup = ''
    # Wrap gApp and override the default global resource file directory
    wrapProgram $out/bin/Rack \
        "''${gappsWrapperArgs[@]}" \
        --add-flags "-s $out/share/vcv-rack"
  '';

  meta = with lib; {
    description = "Open-source virtual modular synthesizer";
    homepage = "https://vcvrack.com/";
    # The source is GPL3+ licensed, some of the art is CC-BY-NC 4.0 or under a
    # no-derivatives clause
    license = with licenses; [ gpl3Plus cc-by-nc-40 unfreeRedistributable ];
    maintainers = with maintainers; [ nathyong jpotier ddelabru ];
    mainProgram = "Rack";
    platforms = platforms.linux;
  };
}
