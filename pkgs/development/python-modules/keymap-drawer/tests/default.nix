{
  lib,
  fetchFromGitHub,
  runCommand,
  stdenv,
  testers,

  keymap-drawer,
  yamllint,
}:
let
  runKeymapDrawer =
    name:
    runCommand "keymap-drawer-${name}" {
      nativeBuildInputs = [ keymap-drawer ];
    };

  MattSturgeon-example = fetchFromGitHub {
    owner = "MattSturgeon";
    repo = "glove80-config";
    rev = "d55267dd26593037256b35a5d6ebba0f75541da5";
    hash = "sha256-MV6cNpgHBuaGvpu2aR1aBNMpwPnDqOSbGf+2ykxocP4=";
    nonConeMode = true;
    sparseCheckout = [
      "config"
      "img"
    ];
  };

  # MattSturgeon's example requires MDI icons
  mdi = fetchFromGitHub {
    owner = "Templarian";
    repo = "MaterialDesign-SVG";
    tag = "v7.4.47";
    hash = "sha256-NoSSRT1ID38MT70IZ+7h/gMVCNsjNs3A2RX6ePGwuQ0=";
  };
in
{
  dump-config = runKeymapDrawer "dump-config" ''
    keymap dump-config --output "$out"

    if [ ! -s "$out" ]; then
      >&2 echo 'Expected `dump-config` to have content.'
      exit 1
    fi

    ${lib.getExe yamllint} --strict --config-data relaxed "$out"
  '';

  parse-zmk = testers.testEqualContents {
    assertion = "keymap parse --zmk-keymap produces expected YAML";
    expected = "${MattSturgeon-example}/img/glove80.yaml";
    actual = runKeymapDrawer "parse" ''
      keymap \
        --config ${MattSturgeon-example}/config/keymap_drawer.yaml \
        parse --zmk-keymap ${MattSturgeon-example}/config/glove80.keymap \
        --output "$out"
    '';
    checkMetadata = stdenv.buildPlatform.isLinux;
  };

  draw = testers.testEqualContents {
    assertion = "keymap draw produces expected SVG";
    expected = "${MattSturgeon-example}/img/glove80.svg";
    actual = runKeymapDrawer "draw" ''
      ${lib.optionalString stdenv.buildPlatform.isLinux ''
        export XDG_CACHE_HOME="$PWD/cache"
        glyphs="$XDG_CACHE_HOME/keymap-drawer/glyphs"
      ''}
      ${lib.optionalString stdenv.buildPlatform.isDarwin ''
        export HOME="$PWD/home"
        glyphs="$HOME/Library/Caches/keymap-drawer/glyphs"
      ''}
      mkdir -p "$glyphs"

      # Unpack MDI icons into the cache
      for file in ${mdi}/svg/*
      do
        ln -s "$file" "$glyphs/mdi:$(basename "$file")"
      done

      keymap \
        --config ${MattSturgeon-example}/config/keymap_drawer.yaml \
        draw ${MattSturgeon-example}/img/glove80.yaml \
        --output "$out"
    '';
    checkMetadata = stdenv.buildPlatform.isLinux;
  };
}
