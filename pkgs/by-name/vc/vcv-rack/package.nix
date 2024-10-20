{ alsa-lib
, cmake
, copyDesktopItems
, curl
, darwin
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
, rsync
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
    hash = "sha256-Li+PmvgSPc6kg/ZqKtXyjiLD+4XlJBkyE0OUEEaUcZk=";
  };
  fuzzysearchdatabase-source = fetchFromBitbucket {
    owner = "j_norberg";
    repo = "fuzzysearchdatabase";
    rev = "23122d1ff60d936fd766361a30210c954e0c5449";
    hash = "sha256-f+ed6zZGfEuYILXQcUoQ+1Qf4ASvWLQqU1nYHDpdCOk=";
  };
  nanovg-source = fetchFromGitHub {
    owner = "VCVRack";
    repo = "nanovg";
    rev = "0bebdb314aff9cfa28fde4744bcb037a2b3fd756";
    hash = "sha256-HmQhCE/zIKc3f+Zld229s5i5MWzRrBMF9gYrn8JVQzg=";
  };
  nanosvg-source = fetchFromGitHub {
    owner = "memononen";
    repo = "nanosvg";
    rev = "9da543e8329fdd81b64eb48742d8ccb09377aed1";
    hash = "sha256-VOiN6583DtzGYPRkl19VG2QvSzl4T9HaynBuNcvZf94=";
  };
  osdialog-source = fetchFromGitHub {
    owner = "AndrewBelt";
    repo = "osdialog";
    rev = "d0f64f0798c2e47f61d90a5505910ff2d63ca049";
    hash = "sha256-auh2Npc+pG0CoDpZ8gF3zugzqRPpRMXBOvw/bjoqYLQ=";
  };
  oui-blendish-source = fetchFromGitHub {
    owner = "VCVRack";
    repo = "oui-blendish";
    rev = "2fc6405883f8451944ed080547d073c8f9f31898";
    hash = "sha256-/QZFZuI5kSsEvSfMJlcqB1HiZ9Vcf3vqLqWIMEgxQK8=";
  };
  simde-source = fetchFromGitHub {
    owner = "simd-everywhere";
    repo = "simde";
    rev = "416091ebdb9e901b29d026633e73167d6353a0b0";
    hash = "sha256-rhs1LYLh7u955/oIuVcmmliSJ+S8+UxAl/6Mwwx7nhg=";
  };
  tinyexpr-source = fetchFromGitHub {
    owner = "codeplea";
    repo = "tinyexpr";
    rev = "9907207e5def0fabdb60c443517b0d9e9d521393";
    hash = "sha256-FCG91JUG47iAHrtH+WvKuIJyzZw6VBzqvWLm/RNod3U=";
  };
  fundamental-source = fetchFromGitHub {
    owner = "VCVRack";
    repo = "Fundamental";
    rev = "5ed79544161e0fa9a55faa7c0a5f299e828e12ab"; # tip of branch v2
    hash = "sha256-mxdTjl/tOeNInzytyaQIQuHKmgueQSBU3veC7F+82DA=";
  };
  vcv-rtaudio = stdenv.mkDerivation {
    pname = "vcv-rtaudio";
    version = "5.1.0-unstable-2020-01-30";

    src = fetchFromGitHub {
      owner = "VCVRack";
      repo = "rtaudio";
      rev = "ece277bd839603648c80c8a5f145678e13bc23f3"; # tip of master branch
      hash = "sha256-W3QvuOyOqI9P82IwGGHIjFbIgMwLREdwpvGUMxWg94U=";
    };

    nativeBuildInputs = [ cmake pkg-config ];

    buildInputs = lib.optionals stdenv.isLinux [
      alsa-lib libjack2 libpulseaudio
    ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      AVFoundation CoreAudio
    ]);

    cmakeFlags = [
      (lib.cmakeBool "RTAUDIO_API_ALSA" stdenv.isLinux)
      (lib.cmakeBool "RTAUDIO_API_PULSE" stdenv.isLinux)
      (lib.cmakeBool "RTAUDIO_API_JACK" stdenv.isLinux)
      (lib.cmakeBool "RTAUDIO_API_CORE" stdenv.isDarwin)
    ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vcv-rack";
  version = "2.5.1";

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "vcv-rack";
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
    rev = "v${finalAttrs.version}";
    hash = "sha256-EKeBvhdsBTWNnLPs+3rgWZFyNvB3VNM8TTMzY53kS+A=";
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
    substituteInPlace plugin.mk --replace-fail ":= all" ":= dist"
    substituteInPlace plugins/Fundamental/src/Logic.cpp \
      --replace-fail \
        "LightButton<VCVBezelBig, VCVBezelLightBig<WhiteLight>>" \
        "struct rack::componentlibrary::LightButton<VCVBezelBig, VCVBezelLightBig<WhiteLight>>"
  '' + lib.optionalString stdenv.isDarwin ''
    # Darwin needs to build the dist target, which builds the .app container,
    # yet we want to exclude the documentation from dist target.
    substituteInPlace Makefile \
      --replace-fail 'DIST_HTML :=' '#DIST_HTML :='

    # To support macOS drag & drop a custom glfw patch is needed
    # (see https://github.com/glfw/glfw/pull/1579 for details).
    # Since the patch does not apply cleanly on the current glfw contained in nixpkgs
    # disable drag & drop functionality for the time being.
    substituteInPlace adapters/standalone.cpp \
      --replace-fail 'glfwGetOpenedFilenames()' 'NULL'

    # The next version of VCV-Rack should contain a patch that
    # makes the following substituteInPlace obsolete.
    substituteInPlace compile.mk \
      --replace-fail '$(CC) $(CXXFLAGS)' '$(CXX) $(CXXFLAGS)'
  '' + lib.optionalString stdenv.isLinux ''
    # Fix reference to zenity
    substituteInPlace dep/osdialog/osdialog_zenity.c \
      --replace-fail 'zenityBin[] = "zenity"' 'zenityBin[] = "${lib.getExe zenity}"'
  '';

  nativeBuildInputs = [
    copyDesktopItems
    imagemagick
    jq
    libicns
    makeWrapper
    pkg-config
    wrapGAppsHook3
  ] ++ lib.optionals stdenv.isDarwin [ rsync ];

  buildInputs = [
    curl
    ghc_filesystem
    glew
    glfw
    gtk3-x11
    jansson
    libarchive
    libsamplerate
    rtmidi
    speexdsp
    vcv-rtaudio
    zstd
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
    libjack2
    libpulseaudio
    zenity
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    AVFoundation CoreAudio
  ]);

  enableParallelBuilding = true;

  makeFlags = [
    "all" "plugins"
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ] ++ lib.optionals stdenv.isDarwin [ "CODESIGN=" "SED=sed -i" "dist" ];

  installPhase = lib.optionalString stdenv.isLinux ''
    runHook preInstall
    install -Dm555 -t $out/bin Rack
    install -Dm555 -t $out/lib libRack${stdenv.hostPlatform.extensions.sharedLibrary}

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
      install -Dm444 icon_"$size"x"$size"x32.png $out/share/icons/hicolor/"$size"x"$size"/apps/Rack.png
    done;
    runHook postInstall
  '' + lib.optionalString stdenv.isDarwin ''
    runHook preInstall
    mkdir -p $out/Applications
    find dist
    mv dist/"VCV Rack ${lib.versions.major finalAttrs.version} Free.app" $out/Applications
    runHook postInstall
  '';

  dontWrapGApps = true;
  postFixup = lib.optionalString stdenv.isLinux ''
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
    platforms = platforms.linux ++ platforms.darwin;
  };
})
