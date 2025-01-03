{
  lib,
  vintagestory,
  fetchurl,
  makeDesktopItem,
}:
let
  version = "1.20.0-rc.8";
in
vintagestory.overrideAttrs {
  pname = "vintagestory-preview";
  inherit version;

  src = fetchurl {
    url = "https://cdn.vintagestory.at/gamefiles/unstable/vs_client_linux-x64_${version}.tar.gz";
    hash = "sha256-/MPR6PAkZv93zT6YbJatg67aRYfzp9vFRY82gtVksAs=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "vintagestory-preview";
      desktopName = "Vintage Story Preview";
      exec = "vintagestory";
      icon = "vintagestory";
      comment = "Innovate and explore in a sandbox world";
      categories = [ "Game" ];
    })
  ];

  meta.maintainers = with lib.maintainers; [ NotAShelf ];
}
