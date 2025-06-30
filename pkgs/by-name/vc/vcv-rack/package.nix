{
  alsa-lib,
  cmake,
  copyDesktopItems,
  curl,
  fetchFromBitbucket,
  fetchFromGitHub,
  ghc_filesystem,
  glew,
  glfw,
  zenity,
  gtk3-x11,
  imagemagick,
  jansson,
  jq,
  lib,
  libarchive,
  libicns,
  libjack2,
  libpulseaudio,
  libsamplerate,
  makeDesktopItem,
  makeWrapper,
  pkg-config,
  rtmidi,
  speexdsp,
  stdenv,
  wrapGAppsHook3,
  zstd,
}:

let
  # The package repo vendors some of the package dependencies as submodules.
  # Unfortunately, they are not pinned, so we have no guarantee that they
  # will be stable, and therefore, we can't use them directly. Instead
  # we'll have to fetch them separately ourselves.
  pffft-source = fetchFromBitbucket {
    owner = "jpommier";
    repo = "pffft";
    rev = "d7a4c0206a29423478776d6b23a37bbb308f21d5";
    sha256 = "sha256-Ohh0H8O6yhPs6VkuRjbolEVYsGskCrDsnbZm5IuUSPI=";
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
    rev = "ea6a6aca009422bba0dbad4c80df6e6ba0c82183";
    sha256 = "sha256-QCjfaSm1/hstVGzkJc0gFnYhnU5I3oHSCTkAVG5gTt8=";
  };
  osdialog-source = fetchFromGitHub {
    owner = "AndrewBelt";
    repo = "osdialog";
    rev = "0250d6696277c8c586ba68770b1aac614addc71a";
    sha256 = "sha256-SXBtgnxy89xh0ylpOwFbAbKQntmUwpdnD7m2pSPmh2o=";
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
    rev = "51743e7920b6e867678cb50e9c62effe28f70b33";
    sha256 = "sha256-AR/TiSYQgW2bUJl5v1JfCzau7WjTSbNHWJMZd4m/AN8=";
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
    rev = "d12b22a170f2b4e7940572ac13ad24869f8ea806"; # tip of branch v2
    sha256 = "sha256-GK7FqdsFnUkNOfYp2RRWeCyiWv95bqm+LOMeXyueBgo=";
  };
  vcv-rtaudio = stdenv.mkDerivation {
    pname = "vcv-rtaudio";
    version = "unstable-2024-12-22";

    src = fetchFromGitHub {
      owner = "VCVRack";
      repo = "rtaudio";
      rev = "22d64cdcb151e388791caceee8aa0011a6aa46e0"; # tip of master branch
      sha256 = "sha256-BW5XwbsuwbbFDHXnQrUMM+1p7Zy7zjwdHHQFGo2XMv0=";
    };

    nativeBuildInputs = [
      cmake
      pkg-config
    ];

    buildInputs = [
      alsa-lib
      libjack2
      libpulseaudio
    ];

    cmakeFlags = [
      "-DRTAUDIO_API_ALSA=ON"
      "-DRTAUDIO_API_PULSE=ON"
      "-DRTAUDIO_API_JACK=ON"
      "-DRTAUDIO_API_CORE=OFF"
    ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vcv-rack";
  version = "2.6.4";

  src = fetchFromGitHub {
    owner = "VCVRack";
    repo = "Rack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WRDOL/nnAv7kR9L6NImZDZqdN3jhz5+bVWjq5ZZzQCc=";
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

  makeFlags =
    lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
      "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
    ]
    ++ [
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

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = finalAttrs.pname;
      desktopName = "VCV Rack";
      genericName = "Eurorack simulator";
      comment = "Create music by patching together virtual synthesizer modules";
      exec = "Rack";
      icon = "Rack";
      categories = [
        "AudioVideo"
        "AudioVideoEditing"
        "Audio"
      ];
      keywords = [ "music" ];
    })
  ];

  meta = {
    description = "Open-source virtual modular synthesizer";
    homepage = "https://vcvrack.com/";
    changelog = "https://github.com/VCVRack/Rack/blob/v${finalAttrs.version}/CHANGELOG.md";
    # The source is GPL3+ licensed, some of the art is CC-BY-NC 4.0 or under a
    # no-derivatives clause
    license = with lib.licenses; [
      gpl3Plus
      cc-by-nc-40
      unfreeRedistributable
    ];
    maintainers = with lib.maintainers; [
      nathyong
      jpotier
      ddelabru
    ];
    mainProgram = "Rack";
    platforms = lib.platforms.linux;
  };
})
