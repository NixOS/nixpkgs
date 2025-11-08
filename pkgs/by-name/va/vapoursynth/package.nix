{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  makeWrapper,
  runCommandCC,
  runCommand,
  vapoursynth,
  buildEnv,
  zimg,
  libass,
  python3,
  testers,
  darwinMinVersionHook,
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth";
  version = "72";

  src = fetchFromGitHub {
    owner = "vapoursynth";
    repo = "vapoursynth";
    rev = "R${version}";
    hash = "sha256-LRRz4471Rl/HwJ14zAkU/f2Acuofja8c0pGkuWihhsM=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    makeWrapper
  ];
  buildInputs = [
    zimg
    libass
    (python3.withPackages (
      ps: with ps; [
        sphinx
        cython
      ]
    ))
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (darwinMinVersionHook "13.3")
  ];

  enableParallelBuilding = true;
  doInstallCheck = !stdenv.hostPlatform.isDarwin;

  passthru = rec {
    # If vapoursynth is added to the build inputs of mpv and then
    # used in the wrapping of it, we want to know once inside the
    # wrapper, what python3 version was used to build vapoursynth so
    # the right python3.sitePackages will be used there.
    inherit python3;

    withPlugins = import ./plugin-interface.nix {
      inherit
        lib
        python3
        buildEnv
        runCommandCC
        stdenv
        runCommand
        vapoursynth
        makeWrapper
        withPlugins
        ;
    };

    tests.version = testers.testVersion {
      package = vapoursynth;
      # Check Core version to prevent false positive with API version
      version = "Core R${version}";
    };
  };

  postPatch = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    # Export weak symbol nixPluginDir to permit override of default plugin path
    sed -E -i \
      -e 's/(VS_PATH_PLUGINDIR)/(nixPluginDir ? nixPluginDir : \1)/g' \
      -e '1i\extern char const __attribute__((weak)) nixPluginDir[];' \
      src/core/vscore.cpp
  '';

  postInstall = ''
    wrapProgram $out/bin/vspipe \
        --prefix PYTHONPATH : $out/${python3.sitePackages}

    # VapourSynth does not include any plugins by default
    # and emits a warning when the system plugin directory does not exist.
    mkdir $out/lib/vapoursynth
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    libv="$out/lib/libvapoursynth${stdenv.hostPlatform.extensions.sharedLibrary}"
    if ! $NM -g -P "$libv" | grep -q '^nixPluginDir w'; then
      echo "Weak symbol nixPluginDir is missing from $libv." >&2
      exit 1
    fi

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Video processing framework with the future in mind";
    homepage = "http://www.vapoursynth.com/";
    license = licenses.lgpl21;
    platforms = platforms.all;
    maintainers = with maintainers; [
      rnhmjoj
      sbruder
      snaki
    ];
    mainProgram = "vspipe";
  };
}
