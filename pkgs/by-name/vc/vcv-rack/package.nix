{
  alsa-lib,
  apple-sdk_13,
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
  openssl,
  pkg-config,
  rtmidi,
  rsync,
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
    rev = "b453f192d22b1c951d71e8a73f28a37cd96a7b6c"; # tip of branch v2
    hash = "sha256-Wr5G2wgCMIduMqFdIJUtkWQEbvihte/WZb/qUWXGE04=";
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

    nativeBuildInputs = [
      cmake
      pkg-config
    ];

    buildInputs =
      [
        openssl
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        alsa-lib
        libjack2
        libpulseaudio
      ]
      ++ lib.optional stdenv.hostPlatform.isDarwin [ apple-sdk_13 ];

    cmakeFlags = [
      (lib.cmakeBool "RTAUDIO_API_ALSA" stdenv.hostPlatform.isLinux)
      (lib.cmakeBool "RTAUDIO_API_PULSE" stdenv.hostPlatform.isLinux)
      (lib.cmakeBool "RTAUDIO_API_JACK" stdenv.hostPlatform.isLinux)
      (lib.cmakeBool "RTAUDIO_API_CORE" stdenv.hostPlatform.isDarwin)
    ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vcv-rack";
  version = "2.6.0";

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "vcv-rack";
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

  src = fetchFromGitHub {
    owner = "VCVRack";
    repo = "Rack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-leI0wwhYiA8qktJFe6DuZjs6q5tMFQ4WFLD4Ivom5+E=";
  };

  patches = [
    ./rack-minimize-vendoring.patch
  ];

  prePatch =
    ''
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
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      # Fix reference to zenity
      substituteInPlace dep/osdialog/osdialog_zenity.c \
        --replace-fail 'zenityBin[] = "zenity"' 'zenityBin[] = "${lib.getExe zenity}"'
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # * Set VERSION from finalAttrs to avoid build using git to determine version
      # * Darwin needs to build the dist target, which builds the .app container,
      #   yet we want to exclude the documentation from dist target.
      # * Replace path to Fundamental module with path to produced build artifact
      #   to avoid downloading a pre-compiled version
      substituteInPlace Makefile \
        --replace-fail 'VERSION ?= $' 'VERSION ?= ${finalAttrs.version}#$' \
        --replace-fail 'DIST_HTML :=' '#DIST_HTML :=' \
        --replace-fail 'FUNDAMENTAL_FILENAME := Fundamental' 'FUNDAMENTAL_FILENAME := plugins/Fundamental/dist/Fundamental'
      # Skip codesigning
      substituteInPlace plugin.mk \
        --replace-fail '$(CODESIGN)' '#$(CODESIGN)'

      # To support macOS drag & drop a custom glfw patch is needed
      # (see https://github.com/glfw/glfw/pull/1579 for details).
      # Since the patch does not apply cleanly on the current glfw contained in nixpkgs
      # disable drag & drop functionality for the time being.
      substituteInPlace adapters/standalone.cpp \
        --replace-fail 'glfwGetOpenedFilenames()' 'NULL'
    '';

  nativeBuildInputs =
    [
      jq
      makeWrapper
      pkg-config
    ]
    ++ lib.optionals stdenv.isLinux [
      copyDesktopItems
      libicns
      imagemagick
      wrapGAppsHook3
    ]
    ++ lib.optionals stdenv.isDarwin [ rsync ];

  buildInputs =
    [
      curl
      ghc_filesystem
      glew
      glfw
      jansson
      libarchive
      libsamplerate
      rtmidi
      speexdsp
      vcv-rtaudio
      zstd
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      gtk3-x11
      libjack2
      libpulseaudio
      zenity
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_13 ];

  enableParallelBuilding = true;

  makeFlags =
    lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
      "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
    ]
    ++ [
      "all"
      "plugins"
    ];

  postBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # To be able to use enableParallelBuilding = true
    # the dist target needs run after the buildPhase as
    # it depends on the all and plugin targets.
    make "SED=sed -i" dist
  '';

  installPhase =
    ''
      runHook preInstall
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''

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
    ''
    + lib.optionalString stdenv.isDarwin ''
      mkdir -p $out/{bin,Applications}
      mv dist/'VCV Rack ${lib.versions.major finalAttrs.version} Free.app' \
        $out/Applications

      # plugins/Fundamental/dist/Fundamental-*.vcvplugin
      cp -r res cacert.pem Core.json template.vcv LICENSE-GPLv3.txt \
        $out/Applications/'VCV Rack ${lib.versions.major finalAttrs.version} Free.app'/Contents/Resources
    ''
    + ''
      runHook postInstall
    '';

  dontWrapGApps = true;
  postFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      # Wrap gApp and override the default global resource file directory
      wrapProgram $out/bin/Rack \
          "''${gappsWrapperArgs[@]}" \
          --add-flags "-s $out/share/vcv-rack"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      makeWrapper \
        $out/Applications/'VCV Rack ${lib.versions.major finalAttrs.version} Free.app'/Contents/MacOS/Rack \
        $out/bin/${finalAttrs.meta.mainProgram} \
        --add-flags "-s $out/Applications/'VCV Rack ${lib.versions.major finalAttrs.version} Free.app'/Contents/Resources"
    '';

  meta = with lib; {
    description = "Open-source virtual modular synthesizer";
    homepage = "https://vcvrack.com/";
    # The source is GPL3+ licensed, some of the art is CC-BY-NC 4.0 or under a
    # no-derivatives clause
    license = with licenses; [
      gpl3Plus
      cc-by-nc-40
      unfreeRedistributable
    ];
    maintainers = with maintainers; [
      nathyong
      jpotier
      ddelabru
    ];
    mainProgram = "Rack";
    platforms = platforms.linux ++ platforms.darwin;
  };
})
