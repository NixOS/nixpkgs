{ lib
, stdenv
, fetchFromBitbucket
, nix-update-script
, boost
, zlib
# File backends (for decoding and encoding)
, withMp3 ? true
, lame
, withOgg ? true
, libvorbis
, withFlac ? true
, flac
# Audio backends (for playback)
, withOpenal ? false
, openal
, withSDL ? false
, SDL
, withOss ? false
, withAlsa ? stdenv.hostPlatform.isLinux
, alsa-lib
, withPulse ? stdenv.hostPlatform.isLinux
, libpulseaudio
# GUI audio player
, withQt ? true
, qt5
, zip
}:
let
  dlopenBuildInputs = []
    ++ lib.optional withMp3 lame
    ++ lib.optional withOgg libvorbis
    ++ lib.optional withFlac flac
    ++ lib.optional withOpenal openal
    ++ lib.optional withSDL SDL
    ++ lib.optional withAlsa alsa-lib
    ++ lib.optional withPulse libpulseaudio;
  supportWayland = (!stdenv.hostPlatform.isDarwin);
  platformName = "linux";
  staticBuildInputs = [ boost zlib ]
    ++ lib.optional withQt (if (supportWayland) then qt5.qtwayland else qt5.qtbase);
in stdenv.mkDerivation rec {
  pname = "zxtune";
  version = "5061";

  outputs = [ "out" ];

  src = fetchFromBitbucket {
    owner = "zxtune";
    repo = "zxtune";
    rev = "r${version}";
    hash = "sha256-KhGxVq0dDvsAMdnr/MRiVbw6mhl/3Vv7D+NSb+fDhgk=";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex" "r([0-9]+)" ];
  };

  strictDeps = true;

  nativeBuildInputs = lib.optionals withQt [ zip qt5.wrapQtAppsHook ];

  buildInputs = staticBuildInputs ++ dlopenBuildInputs;

  patches = [
    ./disable_updates.patch
  ];

  # Fix use of old OpenAL header path
  postPatch = ''
    substituteInPlace src/sound/backends/gates/openal_api.h \
      --replace "#include <OpenAL/" "#include <AL/"
  '';

  buildPhase = let
    setOptionalSupport = name: var:
      "support_${name}=" + (if (var) then "1" else "");
    makeOptsCommon = [
      ''-j$NIX_BUILD_CORES''
      ''root.version=${src.rev}''
      ''system.zlib=1''
      ''platform=${platformName}''
      ''includes.dirs.${platformName}="${lib.makeSearchPathOutput "dev" "include" buildInputs}"''
      ''libraries.dirs.${platformName}="${lib.makeLibraryPath staticBuildInputs}"''
      ''ld_flags="-Wl,-rpath=\"${lib.makeLibraryPath dlopenBuildInputs}\""''
      (setOptionalSupport "mp3" withMp3)
      (setOptionalSupport "ogg" withOgg)
      (setOptionalSupport "flac" withFlac)
      (setOptionalSupport "openal" withOpenal)
      (setOptionalSupport "sdl" withSDL)
      (setOptionalSupport "oss" withOss)
      (setOptionalSupport "alsa" withAlsa)
      (setOptionalSupport "pulseaudio" withPulse)
    ];
    makeOptsQt = [
      ''tools.uic=${qt5.qtbase.dev}/bin/uic''
      ''tools.moc=${qt5.qtbase.dev}/bin/moc''
      ''tools.rcc=${qt5.qtbase.dev}/bin/rcc''
    ];
  in ''
    runHook preBuild
    make ${builtins.toString makeOptsCommon} -C apps/xtractor
    make ${builtins.toString makeOptsCommon} -C apps/zxtune123
  '' + lib.optionalString withQt ''
    make ${builtins.toString (makeOptsCommon ++ makeOptsQt)} -C apps/zxtune-qt
  '' + ''
    runHook postBuild
  '';

  # Libs from dlopenBuildInputs are found with dlopen. Do not shrink rpath. Can
  # check output of 'out/bin/zxtune123 --list-backends' to verify all plugins
  # load ("Status: Available" or "Status: Failed to load dynamic library...").
  dontPatchELF = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/linux/release/xtractor -t $out/bin
    install -Dm755 bin/linux/release/zxtune123 -t $out/bin
  '' + lib.optionalString withQt ''
    install -Dm755 bin/linux/release/zxtune-qt -t $out/bin
  '' + ''
    runHook postInstall
  '';

  # Only wrap the gui
  dontWrapQtApps = true;
  preFixup = lib.optionalString withQt ''
    wrapQtApp "$out/bin/zxtune-qt"
  '';

  meta = with lib; {
    description = "Crossplatform chiptunes player";
    longDescription = ''
      Chiptune music player with truly extensive format support. Supported
      formats/chips include AY/YM, ZX Spectrum, PC, Amiga, Atari, Acorn, Philips
      SAA1099, MOS6581 (Commodore 64), NES, SNES, GameBoy, Atari, TurboGrafX,
      Nintendo DS, Sega Master System, and more. Powered by vgmstream, OpenMPT,
      sidplay, and many other libraries.
    '';
    homepage = "https://zxtune.bitbucket.io/";
    license = licenses.gpl3;
    # zxtune supports mac and windows, but more work will be needed to
    # integrate with the custom make system (see platformName above)
    platforms = platforms.linux;
    maintainers = with maintainers; [ EBADBEEF ];
    mainProgram = if withQt then "zxtune-qt" else "zxtune123";
  };
}
