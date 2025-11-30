{
  alsa-lib,
  apple-sdk_14,
  cmake,
  copyDesktopItems,
  curl,
  fetchFromBitbucket,
  fetchFromGitHub,
  fetchpatch,
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
  # The revs used here have been determined using git submodule status.
  filesystem-source = fetchFromGitHub {
    owner = "gulrak";
    repo = "filesystem";
    rev = "7e37433f318488ae4bc80f80e12df12a01579874";
    hash = "sha256-dHwNsuuFkhd9Y24KRzGV9Z9UZolNtOtxyA1AEVG7uMU=";
  };
  fuzzysearchdatabase-source = fetchFromBitbucket {
    owner = "j_norberg";
    repo = "fuzzysearchdatabase";
    rev = "23122d1ff60d936fd766361a30210c954e0c5449";
    hash = "sha256-f+ed6zZGfEuYILXQcUoQ+1Qf4ASvWLQqU1nYHDpdCOk=";
  };
  nanosvg-source = fetchFromGitHub {
    owner = "memononen";
    repo = "nanosvg";
    rev = "25241c5a8f8451d41ab1b02ab2d865b01600d949";
    hash = "sha256-b/aBmvuvKScF8zSkyF1tuqL9hov4XVLzKLTpr6p7mIQ=";
  };
  nanovg-source = fetchFromGitHub {
    owner = "VCVRack";
    repo = "nanovg";
    rev = "0bebdb314aff9cfa28fde4744bcb037a2b3fd756";
    hash = "sha256-HmQhCE/zIKc3f+Zld229s5i5MWzRrBMF9gYrn8JVQzg=";
  };
  osdialog-source = fetchFromGitHub {
    owner = "AndrewBelt";
    repo = "osdialog";
    rev = "64482bde25a8e19cc38342ed21aa0e38c2751f6c";
    hash = "sha256-FiejDeZkLoyS7BBwPYBfdOCLxBV8hAFzJAFeTz80tH0=";
  };
  oui-blendish-source = fetchFromGitHub {
    owner = "VCVRack";
    repo = "oui-blendish";
    rev = "2fc6405883f8451944ed080547d073c8f9f31898";
    hash = "sha256-/QZFZuI5kSsEvSfMJlcqB1HiZ9Vcf3vqLqWIMEgxQK8=";
  };
  pffft-source = fetchFromBitbucket {
    owner = "jpommier";
    repo = "pffft";
    rev = "74d7261be17cf659d5930d4830609406bd7553e3";
    hash = "sha256-gYaumUeXYf3axAexGqWI/tYBs1dyebjAESo4o/DTjCA=";
  };
  simde-source = fetchFromGitHub {
    owner = "simd-everywhere";
    repo = "simde";
    rev = "dd0b662fd8cf4b1617dbbb4d08aa053e512b08e4";
    hash = "sha256-21YBpP7jwFqNiOu5Ilu8t9nt+AZmLc3PVEwHAWn7vM8=";
  };
  tinyexpr-source = fetchFromGitHub {
    owner = "codeplea";
    repo = "tinyexpr";
    rev = "4e8cc0067a1e2378faae23eb2dfdd21e9e9907c2";
    hash = "sha256-jYC0kSmYdzJsEaH9gres/NOcfsh+2ymqZAGxNbjus/s=";
  };
  fundamental-source = fetchFromGitHub {
    owner = "VCVRack";
    repo = "Fundamental";
    rev = "v2.6.4";
    hash = "sha256-rpOIMFO17ixgJZDRRg6RdLKorN/XKCUXkapsxN1pmQ4=";
  };
  vcv-rtaudio = stdenv.mkDerivation {
    pname = "vcv-rtaudio";
    version = "5.1.0-unstable-2022-11-22";

    src = fetchFromGitHub {
      owner = "VCVRack";
      repo = "rtaudio";
      rev = "22d64cdcb151e388791caceee8aa0011a6aa46e0"; # tip of master branch
      hash = "sha256-BW5XwbsuwbbFDHXnQrUMM+1p7Zy7zjwdHHQFGo2XMv0=";
    };

    nativeBuildInputs = [
      cmake
      pkg-config
    ];

    buildInputs = [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      libjack2
      libpulseaudio
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin [ apple-sdk_14 ];

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
  version = "2.6.6";

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
    hash = "sha256-v5/zk1eT5PRB4bwpCdlKb0nr7qERDM9jP5Q78F30O78=";
  };

  patches = [
    # N.B.: Loading modules may fail due to symbols used by the moodules
    # not being found, to address this issue the libraries providing the
    # symbols are re-exported when building on Darwin using -Wl,-reexport-l.
    ./rack-minimize-vendoring.patch
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    (fetchpatch {
      name = "fix-segfault-on-linux.patch";
      url = "https://github.com/VCVRack/Rack/pull/1944.patch";
      hash = "sha256-dlndyCfCznGDzlWNWrQTgh+FtmsrrL2DVuRE0xCxUck=";
    })
  ];

  prePatch = ''
    # As we can't use `make dep` to set up the dependencies (as explained
    # above), we do it here manually
    mkdir -p dep/include

    cp -r ${filesystem-source}/* dep/filesystem
    cp -r ${fuzzysearchdatabase-source}/* dep/fuzzysearchdatabase
    cp -r ${nanosvg-source}/* dep/nanosvg
    cp -r ${nanovg-source}/* dep/nanovg
    cp -r ${osdialog-source}/* dep/osdialog
    cp -r ${oui-blendish-source}/* dep/oui-blendish
    cp -r ${pffft-source}/* dep/pffft
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
    # For some unknown reason __yield isn't available on aarch64-linux
    substituteInPlace src/engine/Engine.cpp \
      --replace-fail '__yield();' 'asm volatile("yield");'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # * Set VERSION from finalAttrs to avoid build using git to determine version
    # * Darwin needs to build the dist target, which builds the .app container,
    #   yet we want to exclude the documentation from dist target.
    # * Skip stripping the binary to avoid "unsupported load command" error, which
    #   appears since several libraries are re-exported (see rack-minimize-vendoring.patch)
    # * Replace path to Fundamental module with path to produced build artifact
    #   to avoid downloading a pre-compiled version
    substituteInPlace Makefile \
      --replace-fail 'VERSION ?= $' 'VERSION ?= ${finalAttrs.version}#$' \
      --replace-fail 'DIST_HTML :=' '#DIST_HTML :=' \
      --replace-fail '$(STRIP)' '#$(STRIP)' \
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

  nativeBuildInputs = [
    jq
    makeWrapper
    pkg-config
    zstd
  ]
  ++ lib.optionals stdenv.isLinux [
    copyDesktopItems
    imagemagick
    libicns
    wrapGAppsHook3
  ]
  ++ lib.optionals stdenv.isDarwin [ rsync ];

  buildInputs = [
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
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_14 ];

  enableParallelBuilding = true;

  makeFlags =
    lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
      "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
    ]
    ++ [
      "all"
      "plugins"
    ];

  # To be able to use enableParallelBuilding = true
  # the dist target needs run after the buildPhase as
  # it depends on the all and plugin targets.
  postBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    make "SED=sed -i" dist
  '';

  installPhase = ''
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
