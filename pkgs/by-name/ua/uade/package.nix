{
  lib,
  stdenv,
  fetchFromGitLab,
  gitUpdater,
  bencodetools,
  flac,
  lame,
  libao,
  libzakalwe,
  makeWrapper,
  python3,
  pkg-config,
  sox,
  vorbis-tools,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uade";
  version = "3.05";

  src = fetchFromGitLab {
    owner = "uade-music-player";
    repo = "uade";
    rev = "uade-${finalAttrs.version}";
    hash = "sha256-k6t8EQ/G8PbfRrBMXubn1XfBPvw1qDoMGh5xJKrcX+E=";
  };

  postPatch = ''
    patchShebangs configure

    substituteInPlace src/frontends/mod2ogg/mod2ogg2.sh.in \
      --replace-fail '-e stat' '-n stat' \
      --replace-fail '/usr/local' "$out"

    substituteInPlace python/uade/generate_oscilloscope_view.py \
      --replace-fail "default='uade123'" "default='$out/bin/uade123'"
  '';

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    which
  ];

  buildInputs = [
    bencodetools
    flac
    lame
    libao
    libzakalwe
    sox
    vorbis-tools
  ];

  configureFlags = [
    "--bencode-tools-prefix=${bencodetools}"
    "--libzakalwe-prefix=${libzakalwe}"
    (lib.strings.withFeature true "text-scope")
    (lib.strings.withFeature false "write-audio")
  ];

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  postInstall = ''
    wrapProgram $out/bin/mod2ogg2.sh \
      --prefix PATH : $out/bin:${
        lib.makeBinPath [
          flac
          lame
          sox
          vorbis-tools
        ]
      }

    # This is an old script, don't break expectations by renaming it
    ln -s $out/bin/mod2ogg2{.sh,}
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "uade-"; };

  meta = {
    description = "Plays old Amiga tunes through UAE emulation and cloned m68k-assembler Eagleplayer API";
    homepage = "https://zakalwe.fi/uade/";
    # It's a mix of licenses. "GPL", Public Domain, "LGPL", GPL2+, BSD, LGPL21+ and source code with unknown licenses. E.g.
    # - hippel-coso player is "[not] under any Open Source certified license"
    # - infogrames player is disassembled from Andi Silvas player, unknown license
    # Let's make it easy and flag the whole package as unfree.
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    mainProgram = "uade123";
    platforms = lib.platforms.unix;
  };
})
