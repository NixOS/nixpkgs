let
  artifacts = [ "shell" "lua" "font" ];
in
{ lib
, stdenvNoCC
, fetchurl
, artifactList ? artifacts
}:
let
  pname = "sketchybar-app-font";
  version = "2.0.15";

  selectedSources = map (themeName: builtins.getAttr themeName sources) artifactList;
  sources = {
    font = fetchurl {
      url = "https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v${version}/sketchybar-app-font.ttf";
      hash = "sha256-s1mnoHEozmDNsW0P4z97fupAVElxikia0TYLVHJPAM4=";
    };
    lua = fetchurl {
      url = "https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v${version}/icon_map.lua";
      hash = "sha256-YLr7dlKliKLUEK18uG4ouXfLqodVpcDQzfu+H1+oe/w=";
    };
    shell = fetchurl {
      url = "https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v${version}/icon_map.sh";
      hash = "sha256-ZT/k6Vk/nO6mq1yplXaWyz9HxqwEiVWba+rk+pIRZq4=";
    };
  };
in
lib.checkListOfEnum "${pname}: artifacts" artifacts artifactList
  stdenvNoCC.mkDerivation
{
  inherit pname version;

  srcs = selectedSources;

  unpackPhase = ''
    for s in $selectedSources; do
      b=$(basename $s)
      cp $s ''${b#*-}
    done
  '';

  installPhase = ''
    runHook preInstall

  '' + lib.optionalString (lib.elem "font" artifactList) ''
    install -Dm644 ${sources.font} "$out/share/fonts/truetype/sketchybar-app-font.ttf"

  '' + lib.optionalString (lib.elem "shell" artifactList) ''
    install -Dm755 ${sources.shell} "$out/bin/icon_map.sh"

  '' + lib.optionalString (lib.elem "lua" artifactList) ''
    install -Dm644 ${sources.lua} "$out/lib/${pname}/icon_map.lua"

    runHook postInstall
  '';

  meta = {
    description = "A ligature-based symbol font and a mapping function for sketchybar";
    longDescription = ''
      A ligature-based symbol font and a mapping function for sketchybar, inspired by simple-bar's usage of community-contributed minimalistic app icons.
    '';
    homepage = "https://github.com/kvndrsslr/sketchybar-app-font";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
