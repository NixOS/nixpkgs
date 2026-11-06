{
  lib,
  stdenv,
  fetchFromGitHub,
  godot_4_7,
  python3,
  fluidsynth,
  sox,
  ffmpeg,
  imagemagick,
  soundfont-generaluser-gs,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
}:

let
  godot = godot_4_7;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "trampoline";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "MaximilienNaveau";
    repo = "trampoline";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BAVnLA54uCfjicJGTopWTfxOPD7U7BOF1qDtP39sIDk=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    godot
    # The music and sound effects aren't in the repository: they are
    # generated from tools/audio/ at build time.
    (python3.withPackages (ps: [
      ps.mido
      ps.numpy
      ps.scipy
    ]))
    fluidsynth
    sox
    ffmpeg
    imagemagick
    copyDesktopItems
  ];

  # Godot does not follow semver: build with the version the game is made for.
  preConfigure = ''
    godot_ver="${lib.versions.majorMinor godot.version}"
    godot_expected=$(sed -n -E 's@config/features=PackedStringArray\("([0-9]+\.[0-9]+)".*@\1@p' project.godot)
    [ "$godot_ver" == "$godot_expected" ] || {
      echo "Expected Godot version: $godot_expected; found: $godot_ver" >&2
      exit 1
    }
  '';

  env.SF2_GENERALUSER = "${soundfont-generaluser-gs}/share/soundfonts/GeneralUser-GS.sf2";

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    python3 tools/audio/make_music.py --out assets/audio/music original_le_rebond original_la_grille
    python3 tools/audio/make_sfx.py --out assets/audio/sfx

    mkdir -p $HOME/.local/share/godot/
    ln -s "${godot.export-template}"/share/godot/export_templates "$HOME"/.local/share/godot/
    godot4 --headless --import --path .
    mkdir -p build
    godot4 --headless --export-release Linux ./build/trampoline

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 755 -t $out/libexec ./build/trampoline
    install -D -m 644 -t $out/libexec ./build/trampoline.pck
    # The icon at each size, so desktops pick one instead of shrinking the
    # 512 px one on the fly (blurry in GNOME's dock).
    for size in 16 24 32 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps
      magick ./assets/icon/desktop_icon.png -filter Lanczos -resize ''${size}x''${size} \
        -unsharp 0x0.6+0.5+0 $out/share/icons/hicolor/''${size}x''${size}/apps/trampoline.png
    done
    install -d -m 755 $out/bin
    ln -s $out/libexec/trampoline $out/bin/trampoline

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "trampoline";
      exec = "trampoline";
      icon = "trampoline";
      desktopName = "Trampoline";
      # The game window's WM_CLASS, so desktops match it to this entry.
      startupWMClass = "trampoline";
      comment = "Un jeu pour faire rebondir les mots";
      categories = [
        "Game"
        "BoardGame"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "French word game: build 13 nine-letter words with two-faced letter tiles";
    homepage = "https://github.com/MaximilienNaveau/trampoline";
    changelog = "https://github.com/MaximilienNaveau/trampoline/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      gpl3Only # the game
      ofl # the fonts
      mpl20 # the French dictionary
    ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ maximiliennaveau ];
    mainProgram = "trampoline";
  };
})
