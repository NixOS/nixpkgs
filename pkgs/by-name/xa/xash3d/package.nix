{
  lib,
  stdenv,
  SDL2,
  buildPackages,
  bzip2,
  ensureNewerSourcesForZipFilesHook,
  fetchFromGitHub,
  ffmpeg,
  fontconfig,
  freetype,
  libglvnd,
  libogg,
  libopus,
  libvorbis,
  llvmPackages,
  opusfile,
  pkg-config,
  python3,
  unstableGitUpdater,
  waf,
  dedicatedServer ? false,
  gameDir ? "valve",
  lowMemoryMode ? null,
  withAsyncResolve ? true,
  withBsp2 ? false,
  withCustomSwap ? false,
  withEngineFuzz ? false,
  withEngineTests ? true,
  withFFmpeg ? false,
  withFbdev ? false,
  withFuzzer ? false,
  withGL ? true,
  withGL4ES ? false,
  withGLES1 ? false,
  withGLES2 ? false,
  withGLES3Compat ? false,
  withHL25ExtendedStructs ? false,
  withMdlDec ? true,
  withNull ? false,
  withSoft ? true,
  withUtils ? false,
  withXar ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xash3d";
  version = "unstable-2024-12-04";

  src = fetchFromGitHub {
    owner = "FWGS";
    repo = "xash3d-fwgs";
    rev = "614b9113ad34b3bc9bc87de3cdb8b1914c0633ef";
    hash = "sha256-sfxRFYKJh6PbB0QkTDFjfCLpjb4OVv5yeJHNlY2wwXg=";
    fetchSubmodules = true;
  };

  # Make sure we're using our own libopus
  #
  # Help the launcher find libxash
  postPatch = ''
    substituteInPlace wscript \
      --replace-fail 'opus = 1.4' 'opus = ${libopus.version}'

    substituteInPlace game_launch/game.cpp \
      --replace-fail '#define XASHLIB "libxash." OS_LIB_EXT' '#define XASHLIB "${placeholder "out"}/lib/xash3d/libxash${stdenv.hostPlatform.extensions.sharedLibrary}"'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    ensureNewerSourcesForZipFilesHook
    pkg-config
    python3
    waf.hook
  ];

  buildInputs =
    lib.optionals (!dedicatedServer) [
      SDL2
      bzip2
      fontconfig
      freetype
      libglvnd
      libogg
      libopus
      libvorbis
      opusfile
    ]
    ++ lib.optional (withEngineFuzz || withFuzzer) llvmPackages.compiler-rt
    ++ lib.optional withFFmpeg ffmpeg;

  wafConfigureFlags =
    [
      (lib.enableFeature true "packaging")

      "--build-type"
      "release"

      "--gamedir"
      gameDir
    ]
    ++ lib.optional finalAttrs.finalPackage.doCheck (lib.enableFeature true "tests")
    ++ lib.optionals stdenv.hostPlatform.isStatic (
      map (lib.enableFeature true) [
        "static-gl"
        "static-binary"
      ]
    )
    ++ lib.optional stdenv.hostPlatform.is64bit "--64bits"
    ++ lib.optionals (stdenv.hostPlatform.isWindows && !dedicatedServer) [
      "--sdl2"
      (lib.getLib SDL2)
    ]
    ++ lib.optional (!withAsyncResolve) (lib.enableFeature withAsyncResolve "async-resolve")
    ++ lib.optional (!withGL) (lib.enableFeature withGL "gl")
    ++ lib.optional (!withMdlDec) (lib.enableFeature withMdlDec "utils-mdldec")
    ++ lib.optional (!withSoft) (lib.enableFeature withSoft "soft")
    ++ lib.optional (lowMemoryMode != null) "--low-memory-mode ${toString lowMemoryMode}"
    ++ lib.optional dedicatedServer "--dedicated"
    ++ lib.optional withBsp2 (lib.enableFeature withBsp2 "bsp2")
    ++ lib.optional withCustomSwap (lib.enableFeature withCustomSwap "custom-swap")
    ++ lib.optional withEngineFuzz (lib.enableFeature withEngineFuzz "engine-fuzz")
    ++ lib.optional withEngineTests (lib.enableFeature withEngineTests "engine-tests")
    ++ lib.optional withFFmpeg (lib.enableFeature withFFmpeg "ffmpeg")
    ++ lib.optional withFbdev (lib.enableFeature withFbdev "fbdev")
    ++ lib.optional withFuzzer (lib.enableFeature withFuzzer "fuzzer")
    ++ lib.optional withGL4ES (lib.enableFeature withGL4ES "gl4es")
    ++ lib.optional withGLES1 (lib.enableFeature withGLES1 "gles1")
    ++ lib.optional withGLES2 (lib.enableFeature withGLES2 "gles2")
    ++ lib.optional withGLES3Compat (lib.enableFeature withGLES3Compat "gles3compat")
    ++ lib.optional withHL25ExtendedStructs (
      lib.enableFeature withHL25ExtendedStructs "hl25-extended-structs"
    )
    ++ lib.optional withNull (lib.enableFeature withNull "null")
    ++ lib.optional withUtils (lib.enableFeature withUtils "utils")
    ++ lib.optional withXar (lib.enableFeature withXar "xar");

  wafInstallFlags = [ "--destdir=/" ];

  # TODO: Use emulator to run engine tests
  doCheck = stdenv.hostPlatform.emulatorAvailable buildPackages;

  postInstall = ''
    mkdir -p $out/share/pixmaps
    install -Dm644 game_launch/icon-xash-material.png $out/share/pixmaps/xash3d.png
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "Game engine aimed to provide compatibility with Half-Life Engine and extend it";
    longDescription = ''
      Xash3D FWGS is a game engine, aimed to provide compatibility with Half-Life Engine and extend it, as well as to give game developers well known workflow.

      Xash3D FWGS is a heavily modified fork of an original Xash3D Engine by Unkle Mike.
    '';
    homepage = "https://github.com/FWGS/xash3d-fwgs";
    # This has a lot of licensing issues...best to play it safe
    # see https://github.com/FWGS/xash3d-fwgs/issues/63
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ getchoo ];
    platforms = lib.intersectLists lib.platforms.x86 (lib.platforms.linux ++ lib.platforms.windows);
  };
})
